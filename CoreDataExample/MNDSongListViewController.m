//
//  MNDSongListViewController.m
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 20/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import "MNDSongListViewController.h"
#import "MNDSong+Fetch.h"
#import "MNDDataModel.h"

@interface MNDSongListViewController ()
@property (strong, nonatomic) NSArray *songs;
@end

@implementation MNDSongListViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadSongsAutoFetch:YES];
}

- (void)loadSongsAutoFetch:(BOOL)autoFetch
{
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
    NSManagedObjectContext *context = [[MNDDataModel sharedDataModel] managedObjectContext];
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
    fetchRequest.fetchBatchSize = 40;
    NSError *error;
    NSArray *songs = [context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
      NSLog(@"could not fetch songs: %@", error);
    } else {
      if (songs.count == 0 && autoFetch) {
        [self fetchAndSaveSongs];
      } else {
        self.songs = songs;
        dispatch_async(dispatch_get_main_queue(), ^{
          [self.tableView reloadData];
        });
      }
    }
  });
}

- (void)fetchSongsCompletionHandler:(void (^)(NSDictionary* result, NSError *error))completionHandler
{
  // Get songs from server
  NSString *term = @"great";
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
  NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", term];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"fetch server error: %@", error);
      completionHandler(nil, error);
      return;
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if (httpResponse.statusCode != 200) {
      NSLog(@"expected 200 but got %d instead", httpResponse.statusCode);
      // TODO Create a new NSError object and send it here
      completionHandler(nil, nil);
      return;
    }
    
    NSError *jsonError;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments
                                                             error:&jsonError];
    if (jsonError) {
      NSLog(@"error while parsing json: %@", jsonError);
      completionHandler(nil, jsonError);
      return;
    }
    
    completionHandler(result, nil);
  }];
  [task resume];
}

- (void)insertSongsFromJSONResult:(NSDictionary *)result
{
  NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
  context.persistentStoreCoordinator = [[MNDDataModel sharedDataModel] persistentStoreCoordinator];
  
  for (NSDictionary *songAttributes in result[@"results"]) {
    // Skip non-songs
    if (! [songAttributes[@"kind"] isEqualToString:@"song"]) {
      continue;
    }
    
    // Check whether we've already saved this song into our db. If so, skip this.
    MNDSong *song = [MNDSong songWithIdentifier:songAttributes[@"trackId"] usingManagedObjectContext:context];
    
    if (song) {
      // We've already found this song, skipping it
      NSLog(@"skipping song with id: %@", songAttributes[@"trackId"]);
      continue;
    }
    
    song = [NSEntityDescription insertNewObjectForEntityForName:@"Song" inManagedObjectContext:context];
    [song updateAttributes:songAttributes];
  }
  
  NSError *saveError;
  [context save:&saveError];
  
  if (saveError) {
    NSLog(@"cannot save context: %@", saveError);
    return;
  }
}

- (void)fetchAndSaveSongs
{
  [self fetchSongsCompletionHandler:^(NSDictionary *result, NSError *error) {
    if (error) {
      NSLog(@"Error happened! %@", error);
    } else {
      [self insertSongsFromJSONResult:result];
      dispatch_async(dispatch_get_main_queue(), ^{
        [self loadSongsAutoFetch:NO];
      });
    }
  }];
}

- (IBAction)refreshButtonTapped:(id)sender
{
  [self fetchAndSaveSongs];
}

- (void)deleteAllSongs
{
  NSLog(@"deleting all songs");
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
  NSManagedObjectContext *context = [[MNDDataModel sharedDataModel] managedObjectContext];
  for (NSManagedObject *object in [context executeFetchRequest:fetchRequest error:nil]) {
    [context deleteObject:object];
  }
  [context save:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.songs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"SongCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  MNDSong *song = self.songs[indexPath.row];
  cell.textLabel.text = song.name;
  cell.detailTextLabel.text = song.artistName;
  return cell;
}

@end
