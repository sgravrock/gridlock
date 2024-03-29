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
#import "AppDelegate.h"

@interface BoardViewController () {
	int moveSrc;
	CGPoint dragOriginalCenter;
	BOOL dragging;
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
		dragging = NO;
	}
	
	return self;
}

- (void)viewDidLoad
{
	// Create the game model, using saved game state if available
	self.game = [BoardViewController restoreSavedState];
	
	if (!self.game) {
		self.game = [[Game alloc] init];
	}

	// Set up subviews and gesture recognizers
	[self updateView];
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc]
											 initWithTarget:self action:@selector(handleTap:)];
	[self.boardView addGestureRecognizer:tapRecognizer];
	[self.view addGestureRecognizer:tapRecognizer];
	
	for (CellView *c in self.boardView.cellViews) {
		UIPanGestureRecognizer *dragRecognizer = [[UIPanGestureRecognizer alloc]
												  initWithTarget:self action:@selector(handleDrag:)];
		[c addGestureRecognizer:dragRecognizer];
		[c setUserInteractionEnabled:YES];
	}
}

+ (Game *)restoreSavedState
{
	AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
	NSData *gameState = [appDelegate savedGameState];
	
	if (!gameState) {
		return nil;
	}

	@try {
		NSKeyedUnarchiver *coder = [[NSKeyedUnarchiver alloc] initForReadingWithData:gameState];
		return [[Game alloc] initWithCoder:coder];
	}
	@catch (NSException *ex) {
		NSLog(@"Error restoring saved game state: %@", ex);
		return nil;
	}
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
	if (sender.state == UIGestureRecognizerStateEnded && !dragging) {
		// Figure out which subview (if any) was tapped.
		CGPoint where = [sender locationInView:self.boardView];
		
		for (int i = 0; i < self.boardView.cellViews.count; i++) {
			CellView *cv = [self.boardView.cellViews objectAtIndex:i];
			
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
		
		for (CellView *v in self.boardView.cellViews) {
			v.isHighlighted = v == cellView;
		}
		
		moveSrc = cellIx;
	} else {
		// The user selected the destinaton cell of a move.
		int src = moveSrc;
		moveSrc = -1;
		[[self.boardView.cellViews objectAtIndex:src] setIsHighlighted:NO];
		[self moveFromCell:src toCell:cellIx];
	}
}

- (void)handleDrag:(UIPanGestureRecognizer *)dragGesture
{
	// Drag only if we're not in the middle of a tap-driven move.
	if (moveSrc != -1) {
		return;
	}
	
	CellView *cv = (CellView *)dragGesture.view;
	CGPoint translation = [dragGesture translationInView:self.view];
	NSUInteger srcIx, destIx;
	
	switch (dragGesture.state) {
		case UIGestureRecognizerStateBegan:
			dragOriginalCenter = cv.center;
			dragging = YES;
			break;
			
		case UIGestureRecognizerStateChanged:
			cv.center = CGPointMake(dragOriginalCenter.x + translation.x,
									dragOriginalCenter.y + translation.y);
			break;
			
		case UIGestureRecognizerStateEnded:
			destIx = [self indexOfCellViewUnderCellView:cv];
			
			if (destIx != NSNotFound) {
				srcIx = [self.boardView.cellViews indexOfObject:cv];
				[self moveFromCell:srcIx toCell:destIx];
			}
			
		case UIGestureRecognizerStateFailed:
		case UIGestureRecognizerStateCancelled:
			cv.center = dragOriginalCenter;
			dragging = NO;
			
		case UIGestureRecognizerStatePossible:
			break;
			
	}
}

- (NSUInteger)indexOfCellViewUnderCellView:(CellView *)src
{
	src.userInteractionEnabled = NO; // prevents src from being returned from hitTest:withEvent:
	id target = [self.boardView hitTest:src.center withEvent:nil];
	src.userInteractionEnabled = YES;
	
	return [self.boardView.cellViews indexOfObject:target];
}

- (void)moveFromCell:(NSUInteger)srcIx toCell:(NSUInteger)destIx
{
	[self.game moveFromCell:srcIx toCell:destIx];
	
	if ([self.game freeCells] == 0) {
		[self gameOver];
	} else {
		[self updateView];
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
	[self copyColors:self.game.cells toViews:self.boardView.cellViews];
	[self copyColors:self.game.nextColors toViews:self.previewCells];
	self.score.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.game.score];
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

@end
