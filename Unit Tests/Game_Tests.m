//
//  Game_Tests.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/13/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "Game_Tests.h"
#import "Game.h"
#import "FakeRandomizer.h"

@implementation Game_Tests

- (void)testAllowsMoveToEmptyReachableCell
{
	Game *target = [[Game alloc] init];
	[target.cells replaceObjectAtIndex:0 withObject:[UIColor blueColor]];
	[target.cells replaceObjectAtIndex:1 withObject:[NSNull null]];
	[target moveFromCell:0 toCell:1];
	
	STAssertEqualObjects([target.cells objectAtIndex:0], [NSNull null], @"Source wasn't cleared");
	STAssertEqualObjects([target.cells objectAtIndex:1], [UIColor blueColor],
						 @"Destination wasn't set");
}

- (void)testMoveToSameCellDoesNothing
{
	Game *target = [[Game alloc] init];
	[target.cells replaceObjectAtIndex:0 withObject:[UIColor blueColor]];
	[target moveFromCell:0 toCell:0];
	
	STAssertEqualObjects([target.cells objectAtIndex:0], [UIColor blueColor], @"Cell was changed");
}

- (void)testRejectsMoveToOccupiedCell
{
	Game *target = [[Game alloc] init];
	[target.cells replaceObjectAtIndex:0 withObject:[UIColor blueColor]];
	[target.cells replaceObjectAtIndex:1 withObject:[UIColor redColor]];
	[target moveFromCell:0 toCell:1];
	STAssertEqualObjects([target.cells objectAtIndex:0], [UIColor blueColor], @"Source was changed");
	STAssertEqualObjects([target.cells objectAtIndex:1], [UIColor redColor],
						 @"Destination was changed");
}

- (void)testAddsChipsAfterMove
{
	// First six numbers are alternating locations and color values of the initial chips
	// Next six are for the ones placed after the first move
	Randomizer *r = [[FakeRandomizer alloc] initWithResults:0, 0, 1, 0, 2, 5, 3, 0, 4, 0, 5, 0, -1];
	Game *target = [[Game alloc] initWithRandomizer:r];
	[target moveFromCell:0 toCell:9];
	
	STAssertEqualObjects([target.cells objectAtIndex:0], [NSNull null], @"Wrong value in cell 0");
	
	for (int i = 0; i < target.cells.count; i++) {
		if (i == 9 || (i > 0 && i < 6)) {
			STAssertFalse([[target.cells objectAtIndex:i] isEqual:[NSNull null]],
						  [NSString stringWithFormat:@"Wrong value in cell %d", i]);
		} else {
			STAssertEqualObjects([target.cells objectAtIndex:i], [NSNull null],
								 [NSString stringWithFormat:@"Wrong value in cell %d", i]);
		}
	}
}

- (void)testRejectsMoveToUnreachableCell
{
	Game *target = [[Game alloc] init];
	/*  s x
	 *   xd
	 *  x
	 */
	[target.cells replaceObjectAtIndex:0 withObject:[UIColor blueColor]];
	[target.cells replaceObjectAtIndex:2 withObject:[UIColor blueColor]];
	[target.cells replaceObjectAtIndex:10 withObject:[UIColor blueColor]];
	[target.cells replaceObjectAtIndex:18 withObject:[UIColor blueColor]];
	[target moveFromCell:0 toCell:11];
	STAssertEqualObjects([target.cells objectAtIndex:0], [UIColor blueColor], @"Source was changed");
	STAssertEqualObjects([target.cells objectAtIndex:11], [NSNull null], @"Destination was changed");
}

- (void)testHandlesFiveHorizontally
{
	Randomizer *r = [[FakeRandomizer alloc] initWithResults:0, 0, 10, 0, 2, 0, 16, 0, 17, 0,
					 18, 0, 19, 0, 20, 0, 22, 0, -1];
	Game *target = [[Game alloc] initWithRandomizer:r];
	
	STAssertEquals([target freeCells], 9 * 9 - 3, @"Wrong number of free cells");
	[target moveFromCell:10 toCell:1];
	[target moveFromCell:16 toCell:3];
	[target moveFromCell:17 toCell:4];
	// The row of 5 should be removed and no more cells should be placed.
	STAssertEquals([target freeCells], 9 * 9 - 9 + 5, @"Wrong number of free cells");
	
	for (int i = 0; i < 5; i++) {
		STAssertEqualObjects([target.cells objectAtIndex:i], [NSNull null],
							 [NSString stringWithFormat:@"Wrong value in cell %d", i]);
	}
}

- (void)testFindsHorizontalRunsAtRightEdge
{
	Randomizer *r = [[FakeRandomizer alloc] initWithResults:8, 0, 10, 0, 6, 0, 16, 0, 17, 0,
					 18, 0, 19, 0, 20, 0, 22, 0, -1];
	Game *target = [[Game alloc] initWithRandomizer:r];
	
	STAssertEquals([target freeCells], 9 * 9 - 3, @"Wrong number of free cells");
	[target moveFromCell:10 toCell:7];
	[target moveFromCell:16 toCell:5];
	[target moveFromCell:17 toCell:4];
	// The row of 5 should be removed and no more cells should be placed.
	STAssertEquals([target freeCells], 9 * 9 - 9 + 5, @"Wrong number of free cells");
	
	for (int i = 4; i < 9; i++) {
		STAssertEqualObjects([target.cells objectAtIndex:i], [NSNull null],
							 [NSString stringWithFormat:@"Wrong value in cell %d", i]);
	}
}

- (void)testHandlesMoreThanFiveHorizontally
{
	Randomizer *r = [[FakeRandomizer alloc] initWithResults:0, 0, 10, 0, 2, 0, 16, 0, 17, 0,
					 18, 0, 19, 0, 20, 0, 22, 0, 24, 0, 26, 0, 28, 0, -1];
	Game *target = [[Game alloc] initWithRandomizer:r];
	
	STAssertEquals([target freeCells], 9 * 9 - 3, @"Wrong number of free cells");
	[target moveFromCell:10 toCell:1];
	STAssertEquals([target freeCells], 9 * 9 - 6, @"Wrong number of free cells");
	[target moveFromCell:16 toCell:3];
	STAssertEquals([target freeCells], 9 * 9 - 9, @"Wrong number of free cells");
	[target moveFromCell:17 toCell:5];
	STAssertEquals([target freeCells], 9 * 9 - 12, @"Wrong number of free cells");
	[target moveFromCell:18 toCell:4];
	// The row of 6 should be removed and no more cells should be placed.
	STAssertEquals([target freeCells], 9 * 9 - 12 + 6, @"Wrong number of free cells");
	
	for (int i = 0; i < 6; i++) {
		STAssertEqualObjects([target.cells objectAtIndex:i], [NSNull null],
							 [NSString stringWithFormat:@"Wrong value in cell %d", i]);
	}
}

- (void)testDifferentColorsDontCountAsRuns
{
	Randomizer *r = [[FakeRandomizer alloc] initWithResults:0, 0, 10, 0, 2, 0, 16, 0, 17, 0,
					 18, 0, 19, 0, 20, 0, 22, 0, -1];
	Game *target = [[Game alloc] initWithRandomizer:r];
	
	STAssertEquals([target freeCells], 9 * 9 - 3, @"Wrong number of free cells");
	[target moveFromCell:10 toCell:1];
	[target moveFromCell:16 toCell:3];
	[target moveFromCell:17 toCell:4];
	STAssertEquals([target freeCells], 9 * 9 - 4, @"Wrong number of free cells");
}

- (void)testHandlesFiveByRandomPlacement
{
	Randomizer *r = [[FakeRandomizer alloc] initWithResults:0, 0, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0];
	Game *target = [[Game alloc] initWithRandomizer:r];
	
	STAssertEquals([target freeCells], 9 * 9 - 3, @"Wrong number of free cells");
	[target moveFromCell:0 toCell:11];
	
	// The cells filled at the end of the last move completed a row of 5.
	// The row of 5 should be removed and no more cells should be placed.
	STAssertEquals([target freeCells], 9 * 9 - 1, @"Wrong number of free cells");
	
	for (int i = 1; i < 7; i++) {
		STAssertEqualObjects([target.cells objectAtIndex:i], [NSNull null],
							 [NSString stringWithFormat:@"Wrong value in cell %d", i]);
	}
	
}

// TODO: verify vertical and diagonal sequences and intersections
@end
