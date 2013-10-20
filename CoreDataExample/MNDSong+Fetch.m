//
//  MNDSong+Fetch.m
//  CoreDataExample
//
//  Created by Haldun Bayhantopcu on 20/10/13.
//  Copyright (c) 2013 Monoid. All rights reserved.
//

#import "MNDSong+Fetch.h"

@implementation MNDSong (Fetch)

+ (MNDSong *)songWithIdentifier:(NSNumber *)identifier
      usingManagedObjectContext:(NSManagedObjectContext *)context
{
  NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Song"];
  fetchRequest.predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
  fetchRequest.fetchLimit = 1;
  
  NSError *error;
  NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
  
  if (error) {
    return nil;
  }
  
  if (results.count) {
    return [results firstObject];
  }
  
  return nil;
}

- (instancetype)initWithEntity:(NSEntityDescription *)entity
insertIntoManagedObjectContext:(NSManagedObjectContext *)context
                    attributes:(NSDictionary *)attributes
{
  self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
  if (self) {
    [self updateAttributes:attributes];
  }
  return self;
}

- (void)updateAttributes:(NSDictionary *)attributes
{
  self.identifier = attributes[@"trackId"];
  self.artistName = attributes[@"artistName"];
  self.name = attributes[@"trackName"];
}

@end
