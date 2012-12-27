//
//  Game.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "Game.h"
#import "Randomizer.h"
#define RUN_LENGTH 5

@interface Game() {
	int size;
}

@property (nonatomic, strong) Randomizer *randomizer;
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) NSMutableArray *nextColors;
@property (nonatomic) int score;

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
		self.score = 0;
		self.randomizer = randomizer;
		self.colors = [NSArray arrayWithObjects:[UIColor redColor], [UIColor blueColor],
					   [UIColor yellowColor], [UIColor orangeColor], [UIColor greenColor],
					   [UIColor purpleColor], nil];
		self.nextColors = [NSMutableArray arrayWithObjects:[self randomColor], [self randomColor],
						   [self randomColor], nil];
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

- (int)freeCells
{
	int n = 0;
	
	for (id c in self.cells) {
		if (c == [NSNull null]) {
			n++;
		}
	}
	
	return n;
}

- (void)moveFromCell:(int)srcIx toCell:(int)destIx
{
	if ([self.cells objectAtIndex:destIx] != [NSNull null] ||
		![self canReachCell:destIx fromCell:srcIx]) {
		return;
	}
	
	[self.cells replaceObjectAtIndex:destIx withObject:[self.cells objectAtIndex:srcIx]];
	[self.cells replaceObjectAtIndex:srcIx withObject:[NSNull null]];
	
	NSArray *sequence = [self findRun];
	
	if (sequence) {
		[self clearCells:sequence];
	} else {
		[self placeRandomChips];
		sequence = [self findRun];
		
		if (sequence) {
			[self clearCells:sequence];
		}
	}
}

- (NSString *)toStringForLog
{
	NSMutableString *s = [NSMutableString stringWithString:@"\n"];
	void (^addCap)() = ^{
		[s appendString:@"   +"];
		
		for (int i = 0; i < size ; i++) {
			[s appendString:@"-"];
		}
		
		[s appendString:@"   +\n"];
	};
	
	addCap();
	for (int y = 0; y < size; y++) {
		[s appendFormat:@"%2d |", y * size];
		
		for (int x = 0; x < size; x++) {
			id contents = [self.cells objectAtIndex:x + y * size];
			
			if (contents == [NSNull null]) {
				[s appendString:@" "];
			} else {
				NSAssert(self.colors.count < 10, @"Too many colors to format the log properly");
				[s appendFormat:@"%u", [self.colors indexOfObject:contents]];
			}
		}
		[s appendFormat:@"| %2d\n", y * size + size - 1];
	}
		
	addCap();
	return s;
}

- (NSArray *)findRun
{
	for (int y = 0; y < size; y++) {
		for (int x = 0; x < size; x++) {
			// Vertical
			NSArray *run = [self runFromCellIndex:y * size + x offset:size];
			
			if (x <= size - RUN_LENGTH) {
				if (!run) {
					// Horizontal
					run = [self runFromCellIndex:y * size + x offset:1];
				}
				
				if (!run) {
					// Diagonal down and to the right
					run = [self runFromCellIndex:y * size + x offset:size + 1];
				}
			} else if (!run) {
				// Diagonal down and to the left
				run = [self runFromCellIndex:y * size + x offset:size - 1];

			}
			
			if (run) {
				return run;
			}
		}
	}
	
	return nil;
}

// Returns the run of matching, non-empty cells starting at startIx,
// or nil if it's not a run.
- (NSArray *)runFromCellIndex:(int)i offset:(int)offset
{
	id first = [self.cells objectAtIndex:i];
	
	if (first == [NSNull null]) {
		return NO;
	}
	
	NSMutableArray *candidate = [NSMutableArray arrayWithCapacity:RUN_LENGTH]; // might get bigger
	[candidate addObject:[NSNumber numberWithInt:i]];
	BOOL isVertical = offset % size == 0;
	
	// Continue to the edge of the board or until we hit a non-matching cell
	for (i += offset; i < self.cells.count && (isVertical || i % size != 0) ; i += offset) {
		if (![[self.cells objectAtIndex:i] isEqual:first]) {
			break;
		}
		
		[candidate addObject:[NSNumber numberWithInt:i]];
	}
	
	if (candidate.count >= RUN_LENGTH) {
		return candidate;
	}
	
	return nil;
}

- (NSArray *)NSrrayFromInts:(int *)candidates
{
	NSMutableArray *a = [NSMutableArray arrayWithCapacity:RUN_LENGTH];
	
	for (int i = 0; i < RUN_LENGTH; i++) {
		[a addObject:[NSNumber numberWithInt:candidates[i]]];
	}
	
	return a;
}

- (void)clearCells:(NSArray *)indexes
{
	for (NSNumber *n in indexes) {
		[self.cells replaceObjectAtIndex:[n intValue] withObject:[NSNull null]];
	}
	
	// Score 10 points plus an extra 5 for each cell beyond 5
	// e.g. a run of 6 is worth 15 points
	self.score += 10 + (indexes.count - 5) * 5;
}

- (void)placeRandomChips
{
	// Randomly place up to three random colors.
	int toPlace = MIN(3, [self freeCells]);
	int placed = 0;
	
	while (placed < toPlace) {
		int where = [self.randomizer randomBelow:size * size];
	
		if ([self.cells objectAtIndex:where] == [NSNull null]) {
			[self.cells replaceObjectAtIndex:where
								  withObject:[self.nextColors objectAtIndex:placed++]];
		}
	}
	
	for (int i = 0; i < 3; i++ ) {
		[self.nextColors replaceObjectAtIndex:i withObject:[self randomColor]];
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
