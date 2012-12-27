//
//  ViewController.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "BoardViewController.h"
#import "BoardView.h"
#import "Game.h"
#import "CellView.h"
#import "Alert.h"

@interface BoardViewController () {
	int moveSrc;
}
@property (nonatomic, strong) Game *game;
- (void)updateView;
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
	[self updateView];
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
											 initWithTarget:self action:@selector(handleTap:)];
	[self.boardView addGestureRecognizer:tapRecognizer];
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded) {
		// Figure out which subview (if any) was tapped.
		CGPoint where = [sender locationInView:self.boardView];
		
		for (int i = 0; i < self.boardView.subviews.count; i++) {
			CellView *cv = [self.boardView.subviews objectAtIndex:i];
			
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
		
		for (CellView *v in self.boardView.subviews) {
			v.isHighlighted = v == cellView;
		}
		
		moveSrc = cellIx;
	} else {
		// The user selected the destinaton cell of a move.
		[self.game moveFromCell:moveSrc toCell:cellIx];
		[[self.boardView.subviews objectAtIndex:moveSrc] setIsHighlighted:NO];
		moveSrc = -1;
		
		if ([self.game freeCells] == 0) {
			[self gameOver];
		} else {
			[self updateView];
		}
	}
}

- (void)gameOver
{
	[Alert showWithTitle:@"Game Over" message:@"" andThen:^{
		self.game = [[Game alloc] init];
		[self updateView];
	}];
}

- (void)updateView
{
	[self copyColors:self.game.cells toViews:self.boardView.subviews];
	[self copyColors:self.game.nextColors toViews:self.previewCells];
	self.score.text = [NSString stringWithFormat:@"%d", self.game.score];
}

- (void)copyColors:(NSArray *)colors toViews:(NSArray *)views
{
	for (int i = 0; i < colors.count; i++) {
		CellView *c = [views objectAtIndex:i];
		id color = [colors objectAtIndex:i];
		
		if (color == [NSNull null]) {
			color = nil;
		}
		
		c.color = color;
	}
}

- (void)viewDidUnload {
    [self setPreviewCells:nil];
    [super viewDidUnload];
}
@end
