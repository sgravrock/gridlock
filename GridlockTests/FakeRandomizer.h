//
//  FakeRandomizer.h
//  Gridlock
//
//  Created by Steve Gravrock on 12/14/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Randomizer.h"


@interface FakeRandomizer : Randomizer

// Takes a -1-terminated list of results to return from randomBelow:
- (id)initWithResults:(NSUInteger)firstResult, ...;

- (void)log;

@end
