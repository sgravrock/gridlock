//
//  Alert.h
//  Gridlock
//
//  Created by Steve Gravrock on 12/14/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Alert : NSObject

+ (void)showWithTitle:(NSString *)title message:(NSString *)msg andThen:(void (^)(void))callback;

@end
