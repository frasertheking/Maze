//
//  ChallengeMazeViewController.h
//  Maze
//
//  Created by Fraser King on 2016-04-21.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>
@import SpriteKit;
#import "Maze.h"
#import "AppDelegate.h"
#import "BEMCheckBox.h"
#import <iAd/iAd.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

@interface ChallengeMazeViewController : UIViewController <ADBannerViewDelegate, MCBrowserViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, weak) IBOutlet Maze *mazeView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingTimerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *trailingTimerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mazeViewCenterConstraint;
@property (nonatomic, weak) IBOutlet UIButton *exitButton;
@property (nonatomic, weak) IBOutlet UIButton *gameOverButton;
@property (weak, nonatomic) IBOutlet UIView *setupView;
@property (weak, nonatomic) IBOutlet UIButton *findFriends;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UILabel *playerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *enemyNameLabel;
@property (weak, nonatomic) IBOutlet UIView *playerScore1;
@property (weak, nonatomic) IBOutlet UIView *playerScore2;
@property (weak, nonatomic) IBOutlet UIView *playerScore3;
@property (weak, nonatomic) IBOutlet UIView *playerScore4;
@property (weak, nonatomic) IBOutlet UIView *playerScore5;
@property (weak, nonatomic) IBOutlet UIView *enemyScore1;
@property (weak, nonatomic) IBOutlet UIView *enemyScore2;
@property (weak, nonatomic) IBOutlet UIView *enemyScore3;
@property (weak, nonatomic) IBOutlet UIView *enemyScore4;
@property (weak, nonatomic) IBOutlet UIView *enemyScore5;
@property (nonatomic, weak) IBOutlet UIView *inventoryView;
@property (nonatomic, weak) IBOutlet UIView *lostConnectionView;
@property (nonatomic, weak) IBOutlet UIImageView *itemImage;
@property (nonatomic, weak) IBOutlet UILabel *usePowerupLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic) UIColor* topColor;
@property (nonatomic) UIColor* bottomColor;
@property (nonatomic) UIColor* mazeTopColor;
@property (nonatomic) UIColor* mazeBottomColor;
@property (nonatomic) UIColor* lineTopColor;
@property (nonatomic) UIColor* lineBottomColor;

-(void)sendMazeData:(NSMutableArray*)array;
-(void)sendOpponentPoint:(CGPoint)point;
-(void)finished;
-(void)itemFound:(NSInteger)type;

@end

