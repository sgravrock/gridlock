//
//  BoardView.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "BoardView.h"
#import "CellView.h"

#define SIZE 9
//#define CELL_SIZE 34
#define PADDING 10.0f

@implementation BoardView

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if (self) {
		for (int i = 0; i < SIZE * SIZE; i++) {
			[self addSubview:[[CellView alloc] initWithFrame:CGRectZero]];
		}
		
		// Initialization code
		NSLog(@"initWithCoder");
	}
	
	return self;
}

- (void)layoutSubviews
{
	CGFloat cellSize = floor((self.bounds.size.width - 2 * PADDING) / (float)SIZE);
	
	for (int i = 0; i < SIZE; i++) {
		for (int j = 0; j < SIZE; j++) {
			//CGRect frame = CGRectMake(j * CELL_SIZE , i * CELL_SIZE, CELL_SIZE, CELL_SIZE);
			CGRect frame = CGRectMake(j * cellSize + PADDING , i * cellSize + PADDING,
									  cellSize, cellSize);
			[[self.subviews objectAtIndex:i * SIZE + j] setFrame:frame];
		}
	}
}

@end
