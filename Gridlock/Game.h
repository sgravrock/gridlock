//
//  Game.h
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Randomizer;

@interface Game : NSObject

- (id)init;
- (id)initWithRandomizer:(Randomizer *)randomizer;

// The width and height of the board
@property (nonatomic, readonly) int size;
// The colors of each cell, stored in row-major order. Empty cells are nil.
@property (nonatomic, readonly, strong) NSMutableArray *cells;
// The next three colors that will be placed somewhere on the board at random.
// Each element is a UIColor.
@property (nonatomic, readonly, strong) NSMutableArray *nextColors;

- (int)freeCells;
- (NSString *)toStringForLog;
- (void)moveFromCell:(int)srcIx toCell:(int)destIx;

@end
