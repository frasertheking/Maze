//
//  MazeViewController.h
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SpriteKit;
#import "Maze.h"
#import "AppDelegate.h"
#import "BEMCheckBox.h"
#import "SCLAlertView.h"

@interface MazeViewController : UIViewController

@property (nonatomic, weak) IBOutlet Maze *mazeView;
@property (nonatomic, weak) IBOutlet UILabel *resultLabel;
@property (nonatomic, weak) IBOutlet UIView *timerView;
@property (nonatomic, weak) IBOutlet UIView *inventoryView;
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (nonatomic, weak) IBOutlet UILabel *usePowerupLabel;
@property (nonatomic, weak) IBOutlet UILabel *currentLevelLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingTimerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *trailingTimerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mazeViewCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *timerWidthConstraint;
@property (nonatomic, weak) IBOutlet BEMCheckBox *checkbox;
@property (nonatomic, weak) IBOutlet SKView *particleView;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic) UIColor* topColor;
@property (nonatomic) UIColor* bottomColor;
@property (nonatomic) UIColor* mazeTopColor;
@property (nonatomic) UIColor* mazeBottomColor;
@property (nonatomic) UIColor* lineTopColor;
@property (nonatomic) UIColor* lineBottomColor;


-(void)recreateMaze;
-(void)finished;
-(void)itemFound:(NSInteger)type;
-(void)bonusTimeFound;
@end

