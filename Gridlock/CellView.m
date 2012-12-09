//
//  CellView.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "CellView.h"
#import <QuartzCore/QuartzCore.h>


@implementation CellView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];

	if (self) {
		self.layer.borderColor = [UIColor blackColor].CGColor;
		self.layer.borderWidth = 0.5f;
	}

	return self;
}

@end
