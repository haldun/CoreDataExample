//
//  MNDBundle.h
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 18/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MNDRecording;

@interface MNDBundle : NSManagedObject

@property (nonatomic, retain) NSString * bundleDescription;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSNumber * isPurchased;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSOrderedSet *recordings;
@end

@interface MNDBundle (CoreDataGeneratedAccessors)

- (void)insertObject:(MNDRecording *)value inRecordingsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromRecordingsAtIndex:(NSUInteger)idx;
- (void)insertRecordings:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeRecordingsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInRecordingsAtIndex:(NSUInteger)idx withObject:(MNDRecording *)value;
- (void)replaceRecordingsAtIndexes:(NSIndexSet *)indexes withRecordings:(NSArray *)values;
- (void)addRecordingsObject:(MNDRecording *)value;
- (void)removeRecordingsObject:(MNDRecording *)value;
- (void)addRecordings:(NSOrderedSet *)values;
- (void)removeRecordings:(NSOrderedSet *)values;
@end
