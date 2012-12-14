//
//  Game_Tests.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/13/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "Game_Tests.h"
#import "Game.h"

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

@end
