//
//  HomeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-04-20.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"
#import "DEMazeGenerator.h"
#import "Maze.h"
#import "StarBackgroundScene.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"

@interface HomeViewController ()

@property (nonatomic, weak) IBOutlet FBSDKLoginButton *loginButton;
@property (nonatomic) HTPressableButton *playButton;
@property (nonatomic) HTPressableButton *leaderboardButton;
@property (nonatomic) HTPressableButton *settingsButton;
@property (nonatomic, weak) IBOutlet Maze *mazeView;
@property (nonatomic, weak) IBOutlet Maze *mazeView2;
@property (nonatomic, weak) IBOutlet SKView *particleView;
@property (nonatomic, weak) NSTimer* timer;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)delegate.topColor.CGColor, (id)delegate.bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.publishPermissions = @[@"publish_actions"];
    self.loginButton.backgroundColor = [UIColor clearColor];
    self.topColor = [AppDelegate getRandomColor];
    self.bottomColor = [AppDelegate getRandomColor];
    self.mazeTopColor = [AppDelegate getRandomColor];
    self.mazeBottomColor = [AppDelegate getRandomColor];
    self.lineTopColor = [AppDelegate getRandomColor];
    self.lineBottomColor = [AppDelegate getRandomColor];
    self.mazeView.delegate = self;
    self.mazeView.isCasualMode = YES;
    [self.mazeView initMazeWithSize:25];
    self.mazeView2.delegate = self;
    self.mazeView2.isCasualMode = YES;
    [self.mazeView2 initMazeWithSize:25];
//    [self setupParticles];
    self.particleView.hidden = YES;
    self.mazeView.alpha = 0.15f;
    self.mazeView2.alpha = 0.0f;
   
    self.playButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.center =  CGPointMake(self.view.center.x, self.view.center.y - 20);
    [self.playButton addTarget:self action:@selector(playTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    
    self.leaderboardButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.leaderboardButton setTitle:@"Leaderboard" forState:UIControlStateNormal];
    self.leaderboardButton.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    self.leaderboardButton.buttonColor = [UIColor ht_grapeFruitColor];
    self.leaderboardButton.shadowColor = [UIColor ht_grapeFruitDarkColor];
    [self.leaderboardButton addTarget:self action:@selector(leaderboardTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.leaderboardButton];
    
    self.settingsButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
    self.settingsButton.center =  CGPointMake(self.view.center.x, self.view.center.y + 120);
    self.settingsButton.buttonColor = [UIColor ht_mintColor];
    self.settingsButton.shadowColor = [UIColor ht_mintDarkColor];
    [self.settingsButton addTarget:self action:@selector(settingsTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.settingsButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.timer invalidate];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(redrawMaze) userInfo:nil repeats:YES];
    self.mazeView.hidden = NO;
    self.mazeView2.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.timer invalidate];
    self.mazeView.hidden = YES;
    self.mazeView2.hidden = YES;
}

#pragma mark - Maze 

- (void)setupParticles {
    StarBackgroundScene* scene = [StarBackgroundScene sceneWithSize:self.particleView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleView.allowsTransparency = YES;
    [self.particleView presentScene:scene];
}

- (void)redrawMaze {
    if (self.mazeView.alpha == 0.15f) {
        [UIView animateWithDuration:0.75f animations:^{
            self.mazeView.alpha = 0.0f;
            self.mazeView2.alpha = 0.15f;
        } completion:^(BOOL finished) {
            [self.mazeView initMazeWithSize:25];
        }];
    } else {
        [UIView animateWithDuration:0.75f animations:^{
            self.mazeView.alpha = 0.15f;
            self.mazeView2.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.mazeView2 initMazeWithSize:25];
        }];
    }
}

#pragma mark - IBActions

- (IBAction)playTapped:(id)sender {
    [self performSegueWithIdentifier:@"playSegue" sender:self];
}

- (IBAction)leaderboardTapped:(id)sender {
    [self performSegueWithIdentifier:@"leaderboardSegue" sender:self];
}

- (IBAction)settingsTapped:(id)sender {
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {
    
}

@end
