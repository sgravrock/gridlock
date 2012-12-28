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
#define PADDING 10.0f

@implementation BoardView

- (id)initWithCoder:(NSCoder *)decoder
{
	self = [super initWithCoder:decoder];
	
	if (self) {
		NSMutableArray *views = [NSMutableArray arrayWithCapacity:SIZE * SIZE];
		
		for (int i = 0; i < SIZE * SIZE; i++) {
			CellView *cv = [[CellView alloc] initWithFrame:CGRectZero];
			[self addSubview:cv];
			[views addObject:cv];
		}
		
		self.cellViews = views;
	}
	
	return self;
}

- (void)layoutSubviews
{
	CGFloat cellSize = floor((self.bounds.size.width - 2 * PADDING) / (float)SIZE);
	
	for (int i = 0; i < SIZE; i++) {
		for (int j = 0; j < SIZE; j++) {
			CGRect frame = CGRectMake(j * cellSize + PADDING , i * cellSize + PADDING,
									  cellSize, cellSize);
			[[self.cellViews objectAtIndex:i * SIZE + j] setFrame:frame];
		}
	}
}

@end
