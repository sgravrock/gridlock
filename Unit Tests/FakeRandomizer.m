//
//  FakeRandomizer.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/14/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "FakeRandomizer.h"

@interface FakeRandomizer() {
	int next;
}
@property (nonatomic, strong) NSMutableArray *results;
@end

@implementation FakeRandomizer

- (id)initWithResults:(int)firstResult, ...
{
	self = [super init];
	
	if (self) {
		next = 0;
		self.results = [NSMutableArray arrayWithObject:[NSNumber numberWithInt:firstResult]];
		va_list args;
		va_start(args, firstResult);
		BOOL done = NO;
		
		while (!done) {
			int arg = va_arg(args, int);
			
			if (arg < 0) {
				done = YES;
			} else {
				[self.results addObject:[NSNumber numberWithInt:arg]];
			}
		}
		
	}
	
	return self;
}

- (int)randomBelow:(int)limit
{
	id it = [self.results objectAtIndex:next++]; // will throw if out of range
	return [it intValue];
}

@end