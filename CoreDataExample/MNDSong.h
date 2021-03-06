//
//  MNDSong.h
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 20/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MNDSong : NSManagedObject

@property (nonatomic, retain) NSNumber * identifier;
@property (nonatomic, retain) NSString * artistName;
@property (nonatomic, retain) NSString * name;

@end
