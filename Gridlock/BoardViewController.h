//
//  ViewController.h
//  Gridlock
//
//  Created by Steve Gravrock on 12/8/12.
//  Copyright (c) 2012 Steve Gravrock. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BoardView, CellView, Game;

@interface BoardViewController : UIViewController
@property (nonatomic, weak) IBOutlet BoardView *boardView;
@property (strong, nonatomic) IBOutletCollection(CellView) NSArray *previewCells;
@property (nonatomic, weak) IBOutlet UILabel *score;
@property (nonatomic, readonly, strong) Game *game;

@end
