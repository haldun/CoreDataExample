//
//  MNDArtistListViewController.m
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 20/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import "MNDArtistListViewController.h"
#import "MNDArtist.h"
#import "MNDDataModel.h"

@interface MNDArtistListViewController ()

@property (strong, nonatomic) NSArray *artists;

@end

@implementation MNDArtistListViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadArtists];
}

- (void)loadArtists
{
  NSManagedObjectContext *context = [[MNDDataModel sharedDataModel] managedObjectContext];
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Artist"];
  NSError *fetchError;
  self.artists = [context executeFetchRequest:fetchRequest error:&fetchError];
  if (fetchError) {
    NSLog(@"fetch error: %@", fetchError);
  }
}

- (IBAction)refreshButtonTapped:(id)sender
{
  NSString *term = @"Cem";
  
  // Fetch artists from server
  NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
  NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
  NSString *urlString = [NSString stringWithFormat:@"https://itunes.apple.com/search?term=%@", term];
  NSURL *url = [NSURL URLWithString:urlString];
  NSURLSessionDataTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error) {
      NSLog(@"fetch from server error: %@", error);
      return;
    }
    
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if (httpResponse.statusCode != 200) {
      NSLog(@"got http: %d", httpResponse.statusCode);
      return;
    }
    
    NSError *jsonError;
    NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data
                                                           options:NSJSONReadingAllowFragments                                                             error:&jsonError];
    
    if (jsonError) {
      NSLog(@"json error: %@", jsonError);
      return;
    }
    
    NSLog(@"got result: %@", result);
  }];
  [task resume];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return self.artists.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  MNDArtist *artist = self.artists[indexPath.row];
  cell.textLabel.text = artist.name;
  return cell;
}

@end
