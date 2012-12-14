//
//  Alert.m
//  Gridlock
//
//  Created by Steve Gravrock on 12/14/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import "Alert.h"

@interface Alert() <UIAlertViewDelegate>
@property (nonatomic, strong) Alert *retainSelf;
@property (nonatomic, strong) void (^callback)(void);
@end

@implementation Alert

+ (void)showWithTitle:(NSString *)title message:(NSString *)msg andThen:(void (^)(void))callback
{
	Alert *instance = [[Alert alloc] init];
	[instance showWithTitle:title message:msg andThen:callback];
}

- (void)showWithTitle:(NSString *)title message:(NSString *)msg andThen:(void (^)(void))callback
{
	// The callback is probably on the stack. Copy it so it'll still be alive when we need it.
	self.callback = [callback copy];
	self.retainSelf = self;
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:msg delegate:self
											  cancelButtonTitle:@"OK" otherButtonTitles:nil];
	[alertView show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
	self.callback();
	self.retainSelf = nil;
}


@end
