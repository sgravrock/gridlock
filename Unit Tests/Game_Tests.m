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

- (void)testAllowsMoveToEmptyCell
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
	Randomizer *r = [[FakeRandomizer alloc] initWithResults:0, 0, 1, 0, 2, 0, 3, 0, 4, 0, 5, 0, -1];
	Game *target = [[Game alloc] initWithRandomizer:r];
	[target moveFromCell:0 toCell:9];
	
	STAssertEqualObjects([target.cells objectAtIndex:0], [NSNull null], @"Wrong value in cell 0");
	
	for (int i = 0; i < target.cells.count; i++) {
		if (i == 9 || (i > 0 && i < 6)) {
			STAssertFalse([[target.cells objectAtIndex:i] isEqual:[NSNull null]],
						  [NSString stringWithFormat:@"Wrong value in cell %d", i]);
		} else {
			STAssertEqualObjects([target.cells objectAtIndex:0], [NSNull null],
								 [NSString stringWithFormat:@"Wrong value in cell %d", i]);
		}
	}
}

@end
