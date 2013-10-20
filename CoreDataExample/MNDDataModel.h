//
//  MNDDataModel.h
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 18/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

@import Foundation;
@import CoreData;

@interface MNDDataModel : NSObject

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (MNDDataModel *)sharedDataModel;

@end
