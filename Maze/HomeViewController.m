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
@property (nonatomic) HTPressableButton *storeButton;
@property (nonatomic) HTPressableButton *settingsButton;
@property (nonatomic, weak) IBOutlet Maze *mazeView;
@property (nonatomic, weak) IBOutlet SKView *particleView;

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
    [self setupParticles];
    self.particleView.hidden = YES;
    self.mazeView.alpha = 0.15f;
   
    self.playButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    self.playButton.center =  CGPointMake(self.view.center.x, self.view.center.y - 20);
    [self.playButton addTarget:self action:@selector(playTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.playButton];
    
    self.storeButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.storeButton setTitle:@"Statistics" forState:UIControlStateNormal];
    self.storeButton.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
    self.storeButton.buttonColor = [UIColor ht_grapeFruitColor];
    self.storeButton.shadowColor = [UIColor ht_grapeFruitDarkColor];
    [self.storeButton addTarget:self action:@selector(storeTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.storeButton];
    
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
    self.mazeView.hidden = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.mazeView.hidden = YES;
}

#pragma mark - Maze 

- (void)setupParticles {
    StarBackgroundScene* scene = [StarBackgroundScene sceneWithSize:self.particleView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleView.allowsTransparency = YES;
    [self.particleView presentScene:scene];
}

#pragma mark - IBActions

- (IBAction)playTapped:(id)sender {
    [self performSegueWithIdentifier:@"playSegue" sender:self];
}

- (IBAction)storeTapped:(id)sender {
    [self performSegueWithIdentifier:@"statsSegue" sender:self];
}

- (IBAction)settingsTapped:(id)sender {
    [self performSegueWithIdentifier:@"settingsSegue" sender:self];
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {
    
}

@end
