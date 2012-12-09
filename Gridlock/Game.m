//
//  Game.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "Game.h"

static int random_below(int n) {
	return (int)((double)rand() / ((double)RAND_MAX + 1) * n);
}

@interface Game() {
	int size;
}

@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSArray *colors;
- (UIColor *)randomColor;
@end

@implementation Game

- (id)init
{
	self = [super init];
	
	if (self) {
		size = 9;
		self.colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor blueColor],
					   [UIColor yellowColor], [UIColor orangeColor], [UIColor greenColor],
					   [UIColor purpleColor], nil];
		self.cells = [NSMutableArray arrayWithCapacity:size * size];
		
		for (int i = 0; i < size * size; i++) {
			[self.cells addObject:[NSNull null]];
		}
		
		srand(time(NULL));
		
		// Randomly place three random colors.
		int toPlace = 3;
		
		while (toPlace > 0) {
			int where = random_below(size * size);
			
			if ([self.cells objectAtIndex:where] == [NSNull null]) {
				[self.cells replaceObjectAtIndex:where withObject:[self randomColor]];
				toPlace--;
			}
		}
	}
	
	return self;
}

- (int)size
{
	return size;
}

- (UIColor *)randomColor
{
	return [self.colors objectAtIndex:random_below(self.colors.count)];
}

@end
