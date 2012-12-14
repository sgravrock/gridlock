//
//  ViewController.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "BoardViewController.h"
#import "Game.h"
#import "CellView.h"

@interface BoardViewController () {
	int moveSrc;
}
@property (nonatomic, strong) Game *game;
- (void)updateCells;
@end

@implementation BoardViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		moveSrc = -1;
		self.game = [[Game alloc] init];
	}
	
	return self;
}

- (void)viewDidLoad
{
	[self updateCells];
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
											 initWithTarget:self action:@selector(handleTap:)];
	[self.view addGestureRecognizer:tapRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded) {
		// Figure out which subview (if any) was tapped.
		CGPoint where = [sender locationInView:self.view];
		NSLog(@"x=%f,y=%f", where.x, where.y);
		
		for (int i = 0; i < self.view.subviews.count; i++) {
			CellView *cv = [self.view.subviews objectAtIndex:i];
			
			if (CGRectContainsPoint(cv.frame, where)) {
				[self handleTapInCell:cv atIndex:i];
			}
		}
	}
}

- (void)handleTapInCell:(CellView *)cellView atIndex:(int)cellIx
{
	if (moveSrc < 0) {
		// The user selected the source cell of a move.
		if ([self.game.cells objectAtIndex:cellIx] == [NSNull null]) {
			return; // Can't move an empty cell.
		}
		
		for (CellView *v in self.view.subviews) {
			v.isHighlighted = v == cellView;
		}
		
		moveSrc = cellIx;
	} else {
		// The user selected the destinaton cell of a move.
		// TODO: only allow valid moves
		[self.game moveFromCell:moveSrc toCell:cellIx];
		[[self.view.subviews objectAtIndex:moveSrc] setIsHighlighted:NO];
		moveSrc = -1;
		[self updateCells];
	}
}

- (void)updateCells
{
	for (int i = 0; i < self.game.cells.count; i++) {
		CellView *c = [self.view.subviews objectAtIndex:i];
		id color = [self.game.cells objectAtIndex:i];
		
		if (color == [NSNull null]) {
			color = nil;
		}
		
		c.color = color;
	}
}

@end
