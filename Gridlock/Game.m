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
- (int)cellIndexAbove:(int)index;
- (int)cellIndexBelow:(int)index;
- (int)cellIndexLeftOf:(int)index;
- (int)cellIndexRightOf:(int)index;
- (BOOL)canReachCell:(int)destIx fromCell:(int)srcIx;
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
	if ([self.cells objectAtIndex:destIx] != [NSNull null] ||
		![self canReachCell:destIx fromCell:srcIx]) {
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

- (BOOL)canReachCell:(int)destIx fromCell:(int)srcIx
{
	NSMutableSet *reached = [NSMutableSet set];
	NSMutableSet *toTest = [NSMutableSet setWithObject:[NSNumber numberWithInt:srcIx]];
	
	while (toTest.count > 0) {
		NSNumber *boxed = [toTest anyObject];
		[toTest removeObject:boxed];
		int c = [boxed intValue];
		int neighbors[] = {
			[self cellIndexAbove:c],
			[self cellIndexBelow:c],
			[self cellIndexLeftOf:c],
			[self cellIndexRightOf:c]
		};
		
		// Evaluate all existing cells in the four directions
		for (int i = 0; i < sizeof neighbors / sizeof *neighbors; i++) {
			int n = neighbors[i];
			boxed = [NSNumber numberWithInt:n];
			
			if (n >= 0 && n < self.cells.count &&
				[self.cells objectAtIndex:n] == [NSNull null] &&
				![reached containsObject:boxed]) {
				
				if (n == destIx) {
					return true;
				}
				
				[reached addObject:boxed];
				[toTest addObject:boxed];
			}
		}
	}
	
	return NO;
}
- (int)cellIndexAbove:(int)index
{
	return index - size;
}

- (int)cellIndexBelow:(int)index
{
	return index + size;
}

- (int)cellIndexLeftOf:(int)index
{
	return index % size == 0 ? -1 : index - 1;
}

- (int)cellIndexRightOf:(int)index
{
	return index % size == index - 1 ? -1 : index + 1;
}

@end
