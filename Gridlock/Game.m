//
//  Game.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "Game.h"
#import "Randomizer.h"


@interface Game() {
	int size;
}

@property (nonatomic, strong) Randomizer *randomizer;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSArray *colors;
- (UIColor *)randomColor;
@end

@implementation Game

- (id)init
{
	return [self initWithRandomizer:[[Randomizer alloc] init]];
}

- (id)initWithRandomizer:(Randomizer *)randomizer
{
	self = [super init];
	
	if (self) {
		size = 9;
		self.randomizer = randomizer;
		self.colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor blueColor],
					   [UIColor yellowColor], [UIColor orangeColor], [UIColor greenColor],
					   [UIColor purpleColor], nil];
		self.cells = [NSMutableArray arrayWithCapacity:size * size];
		
		for (int i = 0; i < size * size; i++) {
			[self.cells addObject:[NSNull null]];
		}
		
		[self placeRandomChips];
	}
	
	return self;
}

- (int)size
{
	return size;
}

- (void)moveFromCell:(int)srcIx toCell:(int)destIx
{
	if ([self.cells objectAtIndex:destIx] != [NSNull null]) {
		return;
	}
	
	[self.cells replaceObjectAtIndex:destIx withObject:[self.cells objectAtIndex:srcIx]];
	[self.cells replaceObjectAtIndex:srcIx withObject:[NSNull null]];
	
	// TODO: Don't do this if the move completed five in a row.
	[self placeRandomChips];
}

- (void)placeRandomChips
{
	// Randomly place three random colors.
	int toPlace = 3;
	
	while (toPlace > 0) {
		int where = [self.randomizer randomBelow:size * size];
		
		if ([self.cells objectAtIndex:where] == [NSNull null]) {
			[self.cells replaceObjectAtIndex:where withObject:[self randomColor]];
			toPlace--;
		}
	}

}

- (UIColor *)randomColor
{
	return [self.colors objectAtIndex:[self.randomizer randomBelow:self.colors.count]];
}

@end
