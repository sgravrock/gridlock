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
#define PADDING 2.5f

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
	CGFloat cellSize = [self cellSize];
	
	for (int i = 0; i < SIZE; i++) {
		for (int j = 0; j < SIZE; j++) {
			CGRect frame = CGRectMake(j * cellSize + PADDING , i * cellSize + PADDING,
									  cellSize, cellSize);
			[[self.cellViews objectAtIndex:i * SIZE + j] setFrame:frame];
		}
	}
}

- (void)drawRect:(CGRect)rect
{
	// Draw horizontal and vertical gridlines
	CGFloat cellSize = [self cellSize];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(ctx, 1.0);

	for (int i = 0; i <= SIZE; i++) {
		CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
		CGContextMoveToPoint(ctx, PADDING, i * cellSize + PADDING);
		CGContextAddLineToPoint(ctx, self.bounds.size.width - PADDING, i * cellSize + PADDING);
		CGContextStrokePath(ctx);
	}
	
	for (int i = 0; i <= SIZE; i++) {
		CGContextSetStrokeColorWithColor(ctx, [UIColor blackColor].CGColor);
		CGContextMoveToPoint(ctx, i * cellSize + PADDING, PADDING);
		CGContextAddLineToPoint(ctx, i * cellSize + PADDING, self.bounds.size.width - PADDING);
		CGContextStrokePath(ctx);
	}
}

- (CGFloat)cellSize
{
	return floor((self.bounds.size.width - 2 * PADDING) / (float)SIZE);
}


@end
