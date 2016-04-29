//
//  ChallengeMazeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-04-21.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "ChallengeMazeViewController.h"
#import "DEMazeGenerator.h"
#import "Maze.h"
#import "StarBackgroundScene.h"
#import "AppDelegate.h"

@interface ChallengeMazeViewController ()

@property (nonatomic) int size;
@property (nonatomic) BOOL showingOptions;
@property (nonatomic) BOOL assertFailed;
@property (nonatomic) BOOL bannerIsVisible;
@property (nonatomic) ADBannerView *adBanner;
@property (nonatomic) AppDelegate *appDelegate;
@property (nonatomic) NSNumber *seed;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation ChallengeMazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.size = 20;
    self.gameOverButton.hidden = YES;
    
    [self setGradientBackground];
    self.mazeView.delegate = self;
    self.mazeView.isCasualMode = YES;
    [self.mazeView setupGestureRecognizer:self.view];
    self.seed = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    self.mazeView.seed = self.seed;
    [self sendSeed];
    [self.mazeView initMazeWithSize:self.size];
    self.mazeView.score = 0;
    self.topConstraint.constant = -150;
    self.bottomConstraint.constant = -150;
    self.showingOptions = NO;
    self.mazeView.layer.cornerRadius = 10;
    self.mazeView.layer.masksToBounds = YES;
    self.checkbox.onAnimationType = BEMAnimationTypeFill;
    self.checkbox.offAnimationType = BEMAnimationTypeFill;
    self.checkbox.userInteractionEnabled = NO;
    [self.gameOverButton addTarget:self action:@selector(rematch) forControlEvents:UIControlEventTouchUpInside];
    self.mazeView.hidden = YES;
    self.hideEnemyMazeButton.enabled = NO;
    
    self.checkbox.tintColor = [UIColor clearColor];
    self.checkbox.onCheckColor = SOLVE;
    self.checkbox.onFillColor = SEVERITY_GREEN;
    self.checkbox.onTintColor = SOLVE;
    self.connectedLabel.text = @"Not Connected";
    
    [self setupParallaxEffect];
    [self setupAds];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveDataWithNotification:)
                                                 name:@"MCDidReceiveDataNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(peerDidChangeStateWithNotification:)
                                                 name:@"MCDidChangeStateNotification"
                                               object:nil];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[self.appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
    [[_appDelegate mcManager] advertiseSelf:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    //[self timesUp];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)setupParallaxEffect {
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-8);
    verticalMotionEffect.maximumRelativeValue = @(8);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-8);
    horizontalMotionEffect.maximumRelativeValue = @(8);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.mazeView addMotionEffect:group];
}

-(void)setGradientBackground {
    self.topColor = [AppDelegate getRandomColor];
    self.bottomColor = [AppDelegate getRandomColor];
    self.mazeTopColor = [AppDelegate getRandomColor];
    self.mazeBottomColor = [AppDelegate getRandomColor];
    self.lineTopColor = [AppDelegate getRandomColor];
    self.lineBottomColor = [AppDelegate getRandomColor];
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)delegate.topColor.CGColor, (id)delegate.bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}

-(void)recreateMaze {
    [self.mazeView initMazeWithSize:self.size];
    self.assertFailed = NO;
}

-(void)finished {
    [self sendGameOver];
    self.mazeView.userInteractionEnabled = NO;
    if (!self.assertFailed) {
        [self.gameOverButton setTitle:@"You Won! Rematch?" forState:UIControlStateNormal];
        self.gameOverButton.hidden = NO;
        self.mazeView.hidden = YES;
    }
}

#pragma mark - Actions

- (IBAction)randomizeMaze:(id)sender {
    self.size = 2;
    [self recreateMaze];
}

- (IBAction)solveMaze:(id)sender {
    [self.mazeView solve];
}

- (IBAction)animateMaze:(id)sender {
    [self.mazeView transformMaze];
}

- (IBAction)showOptions:(id)sender {
    if (self.showingOptions) {
        [UIView animateWithDuration:0.5 delay:0.0  options:0 animations:^{
            self.topConstraint.constant = -150;
            self.bottomConstraint.constant = -150;
            self.showingOptions = NO;
            [self.view layoutIfNeeded];
        } completion:nil];
    } else {
        [UIView animateWithDuration:0.5 delay:0.0 options:0 animations:^{
            self.topConstraint.constant = 36;
            self.bottomConstraint.constant = 16;
            self.showingOptions = YES;
            [self.view layoutIfNeeded];
        } completion:nil];
    }
}

- (IBAction)exitGamePressed:(id)sender {
    [UIView animateWithDuration:0.15 animations:^{
        self.exitButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.exitButton.alpha = 0.33;
        } completion:^(BOOL finished) {
            self.mazeView.delegate = nil;
            [[_appDelegate mcManager] advertiseSelf:NO];
            [_appDelegate.mcManager.session disconnect];
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark - Helpers

-(UIColor*) inverseColor:(UIColor*)color {
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    return [[UIColor alloc] initWithRed:(componentColors[0] - 0.25) green:(componentColors[1] - 0.25) blue:(componentColors[2] - 0.25) alpha:componentColors[3] - 0.25];
}

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)pulseView:(UIView*)view {
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.33];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.9];
    [view.layer addAnimation:scaleAnimation forKey:@"scale"];
}

#pragma mark - iAd Delegates

- (void)setupAds {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"adState"]) {
        self.adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        self.adBanner.delegate = self;
    }
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    if (!self.bannerIsVisible) {
        if (self.adBanner.superview == nil) {
            [self.view addSubview:self.adBanner];
        }
        [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, -50);
        [UIView commitAnimations];
        self.bannerIsVisible = YES;
    }
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    NSLog(@"Failed to retrieve ad");
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

#pragma mark - Private method implementation

-(void)sendSeed{
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject: self.seed];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
       // NSLog(@"Sent data!!");
    }
}

-(void)sendMazeData:(NSMutableArray*)array{
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject: array];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        // NSLog(@"Sent data!!");
    }
}

-(void)sendGameOver {
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject: @"Game Over"];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        // NSLog(@"Sent data!!");
    }
}

-(void)sendHideMaze {
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject: @"hide"];
    NSArray *allPeers = self.appDelegate.mcManager.session.connectedPeers;
    NSError *error;
    
    [_appDelegate.mcManager.session sendData:dataToSend
                                     toPeers:allPeers
                                    withMode:MCSessionSendDataReliable
                                       error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    } else {
        // NSLog(@"Sent data!!");
    }
}

-(void)didReceiveDataWithNotification:(NSNotification *)notification{
    NSData *receivedData = [[notification userInfo] objectForKey:@"data"];
    id dataType = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];

    if ([dataType isKindOfClass:[NSMutableArray class]]) {
        NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.mazeView drawOpponentAttempt:array];
        });
    } else if ([dataType isKindOfClass:[NSNumber class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.gameOverButton.hidden = YES;
            self.mazeView.hidden = NO;
            self.hideEnemyMazeButton.enabled = YES;
            self.mazeView.mazeViewMask.alpha = 1;
            self.mazeView.userInteractionEnabled = YES;
            self.mazeView.seed = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
            [self.mazeView initMazeWithSize:self.size];
            self.connectedLabel.text = @"Connected";
        });
    } else {
        if ([[NSKeyedUnarchiver unarchiveObjectWithData:receivedData] isEqualToString:@"hide"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:2 animations:^{
                    self.mazeView.mazeViewMask.alpha = 0;
                } completion:^(BOOL finished) {
                    [UIView animateWithDuration:4 animations:^{
                        self.mazeView.mazeViewMask.alpha = 1;
                    }];
                }];
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mazeView.userInteractionEnabled = NO;
                self.hideEnemyMazeButton.enabled = NO;
                [self.gameOverButton setTitle:@"You Lost! Rematch?" forState:UIControlStateNormal];
                self.gameOverButton.hidden = NO;
                self.mazeView.hidden = YES;
            });
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)rematch {
    self.gameOverButton.hidden = YES;
    self.mazeView.userInteractionEnabled = YES;
    self.seed = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    self.mazeView.seed = self.seed;
    [self sendSeed];
    [self.mazeView initMazeWithSize:self.size];
    self.mazeView.hidden = NO;
    self.hideEnemyMazeButton.enabled = YES;
    self.mazeView.mazeViewMask.alpha = 1;
}

- (IBAction)setHideEnemyMaze:(id)sender {
    self.hideEnemyMazeButton.enabled = NO;
    [self sendHideMaze];
}

- (IBAction)browseForDevices:(id)sender {
    [[_appDelegate mcManager] setupMCBrowser];
    [[[_appDelegate mcManager] browser] setDelegate:self];
    [self presentViewController:[[_appDelegate mcManager] browser] animated:YES completion:nil];
    self.appDelegate.mcManager.peer = YES;
}

#pragma mark - MCBrowserViewControllerDelegate method implementation

-(void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}


-(void)browserViewControllerWasCancelled:(MCBrowserViewController *)browserViewController{
    [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private method implementation

-(void)peerDidChangeStateWithNotification:(NSNotification *)notification{
    MCSessionState state = [[[notification userInfo] objectForKey:@"state"] intValue];
    
    if (state != MCSessionStateConnecting) {
        if (state == MCSessionStateConnected) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.gameOverButton.hidden = YES;
                self.mazeView.userInteractionEnabled = YES;
                self.seed = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
                self.mazeView.seed = self.seed;
                [self sendSeed];
                [self.mazeView initMazeWithSize:self.size];
                self.mazeView.hidden = NO;
                self.hideEnemyMazeButton.enabled = YES;
                self.mazeView.mazeViewMask.alpha = 1;
                self.connectedLabel.text = @"Connected";
            });
        }
        else if (state == MCSessionStateNotConnected) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.connectedLabel.text = @"Not Connected";
            });
        }
    }
}


@end
