//
//  AdventureLevelViewController.h
//  Maze
//
//  Created by Fraser King on 2016-05-06.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SpriteKit;
#import "Maze.h"
#import "AppDelegate.h"
#import "BEMCheckBox.h"
#import <iAd/iAd.h>

@interface AdventureLevelViewController : UIViewController <ADBannerViewDelegate>

@property (nonatomic, weak) IBOutlet Maze *mazeView;
@property (nonatomic, weak) IBOutlet UIView *timerView;
@property (nonatomic, weak) IBOutlet UIView *inventoryView;
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (nonatomic, weak) IBOutlet UILabel *usePowerupLabel;
@property (nonatomic, weak) IBOutlet UIButton *exitButton;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingTimerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *trailingTimerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mazeViewCenterConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *timerWidthConstraint;
@property (nonatomic, weak) IBOutlet BEMCheckBox *checkbox;
@property (nonatomic, weak) IBOutlet SKView *particleView;
@property (nonatomic, weak) IBOutlet UIView *levelFailedView;
@property (nonatomic, weak) IBOutlet UIView *levelFinishedView;
@property (weak, nonatomic) IBOutlet UIView *score1View;
@property (weak, nonatomic) IBOutlet UIView *score2View;
@property (weak, nonatomic) IBOutlet UIView *score3View;
@property (weak, nonatomic) IBOutlet UIView *score4View;
@property (weak, nonatomic) IBOutlet UIView *score5View;
@property (nonatomic) int level;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic) UIColor* topColor;
@property (nonatomic) UIColor* bottomColor;
@property (nonatomic) UIColor* mazeTopColor;
@property (nonatomic) UIColor* mazeBottomColor;
@property (nonatomic) UIColor* lineTopColor;
@property (nonatomic) UIColor* lineBottomColor;
@property (nonatomic) int timeRemaining;

-(void)recreateMaze;
-(void)finished;
-(void)itemFound:(NSInteger)type;
-(void)bonusTimeFound;
-(void)setGradientBackground;
@end
