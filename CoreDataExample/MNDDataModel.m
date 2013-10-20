//
//  MNDDataModel.m
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 18/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import "MNDDataModel.h"

@interface MNDDataModel ()

@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

@end

@implementation MNDDataModel

+ (MNDDataModel *)sharedDataModel
{
  static dispatch_once_t onceToken;
  static MNDDataModel *_sharedInstance;
  dispatch_once(&onceToken, ^{
    _sharedInstance = [[MNDDataModel alloc] init];
  });
  return _sharedInstance;
}

- (instancetype)init
{
  self = [super init];
  if (self) {
    NSString *pathToModel = [[NSBundle mainBundle] pathForResource:@"CoreDataExample" ofType:@"momd"];
    NSURL *storeUrl = [NSURL fileURLWithPath:pathToModel];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:storeUrl];
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_managedObjectModel];
    NSString *dbFilename = @"db.sqlite3";
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                       NSUserDomainMask, YES)[0];
    NSString *pathToLocalStore = [documentsDirectory stringByAppendingPathComponent:dbFilename];
    NSURL *dbUrl = [NSURL fileURLWithPath:pathToLocalStore];
    NSDictionary *options = @{
                              NSMigratePersistentStoresAutomaticallyOption: @YES,
                              NSInferMappingModelAutomaticallyOption: @YES
                              };
    NSError *error;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                   configuration:nil
                                                             URL:dbUrl
                                                         options:options
                                                           error:&error]) {
      NSDictionary *userInfo = [NSDictionary dictionaryWithObject:error forKey:NSUnderlyingErrorKey];
      NSString *reason = @"Could not create persistent store.";
      NSException *exc = [NSException exceptionWithName:NSInternalInconsistencyException
                                                 reason:reason
                                               userInfo:userInfo];
      NSLog(@"%@", error);
      @throw exc;
    }
    
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    _managedObjectContext.persistentStoreCoordinator = _persistentStoreCoordinator;
  }
  return self;
}

@end
