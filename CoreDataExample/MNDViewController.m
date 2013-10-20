//
//  MNDViewController.m
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 18/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import "MNDViewController.h"
#import "MNDDataModel.h"
#import "MNDBundle.h"
#import "MNDRecording.h"

@interface MNDViewController ()

@property (strong, nonatomic) NSArray *bundles;

@end

@implementation MNDViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self loadData];
}

- (void)loadData
{
  NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Bundle"];
  NSError *error;
  self.bundles = [[[MNDDataModel sharedDataModel] managedObjectContext] executeFetchRequest:fetchRequest error:&error];
  
  if (error) {
    NSLog(@"error: %@", error);
  } else {
    [self.tableView reloadData];
  }
}

- (IBAction)createBundles:(id)sender
{
//  NSManagedObjectContext *context = [[MNDDataModel sharedDataModel] managedObjectContext];
//  MNDBundle *bundle = [NSEntityDescription insertNewObjectForEntityForName:@"Bundle"
//                                                    inManagedObjectContext:context];
//  bundle.title = @"hell yeah!";
//  bundle.isPurchased = @YES;
//
//  MNDRecording *recording = [NSEntityDescription insertNewObjectForEntityForName:@"Recording"
//                                                          inManagedObjectContext:context];
//  recording.identifier = @1;
//  recording.title = [NSString stringWithFormat:@"Recording 1"];
//  recording.bundle = bundle;
  
//  for (int i = 1; i <= 10; ++i) {
//    MNDRecording *recording = [NSEntityDescription insertNewObjectForEntityForName:@"Recording"
//                                                            inManagedObjectContext:context];
//    recording.title = [NSString stringWithFormat:@"Recording %i", i];
//    recording.bundle = bundle;
//  }
  
//  [context save:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return _bundles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  static NSString *CellIdentifier = @"BundleCell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
  
  MNDBundle *bundle = _bundles[indexPath.row];
  cell.textLabel.text = bundle.title;
  
  if ([bundle.isPurchased boolValue]) {
    cell.backgroundColor = [UIColor grayColor];
  } else {
    cell.backgroundColor = [UIColor clearColor];
  }
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  MNDBundle *bundle = self.bundles[indexPath.row];
  NSLog(@"%@", bundle);
}

@end
