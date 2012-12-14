//
//  Game.h
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Game : NSObject

// The width and height of the board
@property (nonatomic, readonly) int size;
// The colors of each cell, stored in row-major order. Empty cells are nil.
@property (nonatomic, readonly, strong) NSMutableArray *cells;

- (void)moveFromCell:(int)srcIx toCell:(int)destIx;

@end
