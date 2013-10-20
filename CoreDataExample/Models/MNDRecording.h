//
//  MNDRecording.h
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 18/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MNDBundle;

@interface MNDRecording : NSManagedObject

@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) MNDBundle *bundle;

@end
