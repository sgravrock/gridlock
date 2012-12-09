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

@interface BoardViewController ()
@property (nonatomic, strong) Game *game;
- (void)updateCells;
@end

@implementation BoardViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	self = [super initWithCoder:aDecoder];
	
	if (self) {
		self.game = [[Game alloc] init];
	}
	
	return self;
}

- (void)viewDidLoad
{
	[self updateCells];
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
