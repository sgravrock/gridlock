//
//  CellView.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "CellView.h"
#import <math.h>
#import <QuartzCore/QuartzCore.h>


@implementation CellView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		self.layer.borderColor = [UIColor blackColor].CGColor;
		self.layer.borderWidth = 0.5f;
		self.layer.backgroundColor = [UIColor grayColor].CGColor;
	}

	return self;
}

- (void)setColor:(UIColor *)color
{
	_color = color;
	[self setNeedsDisplay];
}

- (void)setIsHighlighted:(BOOL)value
{
	_isHighlighted = value;
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	// TODO: Higlight cells in a way that isn't so crude.
	UIColor *bgColor = self.isHighlighted ? [UIColor blackColor] : [UIColor whiteColor];
	CGContextSetFillColorWithColor(ctx, bgColor.CGColor);
	
	CGContextFillRect(ctx, self.bounds);

	if (self.color) {
		CGFloat center = self.bounds.size.width / 2; // We should be square.
		CGFloat radius = center - 2;
		CGContextAddArc(ctx, center, center, radius, 0, 2 * M_PI, 1);
		CGContextSetFillColorWithColor(ctx, self.color.CGColor);
		CGContextFillPath(ctx);
	}
}

@end
