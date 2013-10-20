//
//  MNDSong+Fetch.h
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 20/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import "MNDSong.h"

@interface MNDSong (Fetch)

+ (MNDSong *)songWithIdentifier:(NSNumber *)identifier
      usingManagedObjectContext:(NSManagedObjectContext *)context;

- (instancetype)initWithEntity:(NSEntityDescription *)entity
insertIntoManagedObjectContext:(NSManagedObjectContext *)context
                    attributes:(NSDictionary *)attributes;

- (void)updateAttributes:(NSDictionary *)attributes;

@end
