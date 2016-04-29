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

@interface ChallengeMazeViewController : UIViewController <ADBannerViewDelegate, MCBrowserViewControllerDelegate>

@property (nonatomic, weak) IBOutlet Maze *mazeView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *leadingTimerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *trailingTimerConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *mazeViewCenterConstraint;
@property (nonatomic, weak) IBOutlet BEMCheckBox *checkbox;
@property (nonatomic, weak) IBOutlet UIButton *exitButton;
@property (nonatomic, weak) IBOutlet UIButton *gameOverButton;
@property (weak, nonatomic) IBOutlet UIButton *findPlayers;
@property (weak, nonatomic) IBOutlet UILabel *connectedLabel;

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomConstraint;

@property (nonatomic) UIColor* topColor;
@property (nonatomic) UIColor* bottomColor;
@property (nonatomic) UIColor* mazeTopColor;
@property (nonatomic) UIColor* mazeBottomColor;
@property (nonatomic) UIColor* lineTopColor;
@property (nonatomic) UIColor* lineBottomColor;

-(void)sendMazeData:(NSMutableArray*)array;
-(void)finished;
@end

