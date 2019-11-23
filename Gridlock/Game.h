//
//  Game.h
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Randomizer;

@interface Game : NSObject<NSCoding>

- (id)init;
- (id)initWithRandomizer:(Randomizer *)randomizer;

// The width and height of the board
@property (nonatomic, readonly) NSUInteger size;
// The colors of each cell, stored in row-major order. Empty cells are nil.
@property (nonatomic, readonly, strong) NSMutableArray *cells;
// The next three colors that will be placed somewhere on the board at random.
// Each element is a UIColor.
@property (nonatomic, readonly, strong) NSMutableArray *nextColors;
@property (nonatomic, readonly) NSUInteger score;

- (NSUInteger)freeCells;
- (NSString *)toStringForLog;
- (void)moveFromCell:(NSUInteger)srcIx toCell:(NSUInteger)destIx;

@end
