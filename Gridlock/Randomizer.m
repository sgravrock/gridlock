//
//  Randomizer.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/14/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "Randomizer.h"

@implementation Randomizer

- (id)init
{
	self = [super init];
	
	if (self) {
		srand(time(NULL));
		return [super init];
	}
	
	return self;
}

- (int)randomBelow:(int)limit
{
	return (int)((double)rand() / ((double)RAND_MAX + 1) * limit);
}


@end
