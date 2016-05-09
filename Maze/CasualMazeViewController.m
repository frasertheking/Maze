//
//  CasualMazeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-04-21.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "CasualMazeViewController.h"
#import "DEMazeGenerator.h"
#import "Maze.h"
#import "StarBackgroundScene.h"
#import "AppDelegate.h"

@interface CasualMazeViewController ()

@property (nonatomic) int size;
@property (nonatomic) BOOL showingOptions;
@property (nonatomic) BOOL assertFailed;
@property (nonatomic) BOOL bannerIsVisible;
@property (nonatomic) ADBannerView *adBanner;

@end

@implementation CasualMazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = 2;
    self.mazeView.isCasualMode = YES;
    
    [self setGradientBackground];
    self.mazeView.delegate = self;
    [self.mazeView setupGestureRecognizer:self.view];
    //[self.mazeView initMazeWithSize:self.size];
    self.mazeView.score = 0;
    self.topConstraint.constant = -150;
    self.bottomConstraint.constant = -150;
    self.showingOptions = NO;
    self.mazeView.layer.cornerRadius = 10;
    self.mazeView.layer.masksToBounds = YES;
    self.checkbox.onAnimationType = BEMAnimationTypeFill;
    self.checkbox.offAnimationType = BEMAnimationTypeFill;
    self.checkbox.userInteractionEnabled = NO;
   
    [self setCurrentLevelLabel];
    
    self.checkbox.tintColor = [UIColor clearColor];
    self.checkbox.onCheckColor = SOLVE;
    self.checkbox.onFillColor = SEVERITY_GREEN;
    self.checkbox.onTintColor = SOLVE;
    
    self.mazeView.alpha = 0;
    self.currentLevelLabel.alpha = 0;
    
    [self setupParticles];
    [self setupParallaxEffect];
    [self setupAds];
    [self goInThree];
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

#pragma mark - Countdown

- (void)goInThree {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goInTwo) userInfo:nil repeats:NO];
    self.countdownLabel.text = @"Begin in 3";
}

- (void)goInTwo {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goInOne) userInfo:nil repeats:NO];
    self.countdownLabel.text = @"Begin in 2";
}


- (void)goInOne {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goNow) userInfo:nil repeats:NO];
    self.countdownLabel.text = @"Begin in 1";
}

- (void)goNow {
    [self recreateMaze];
    [UIView animateWithDuration:0.25 delay:0.1 options:0 animations:^{
        self.countdownLabel.alpha = 0;
        self.mazeView.alpha = 1;
        self.currentLevelLabel.alpha = 1;
    } completion:nil];
}

- (void)setupParticles {
    StarBackgroundScene* scene = [StarBackgroundScene sceneWithSize:self.particleView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleView.allowsTransparency = YES;
    [self.particleView presentScene:scene];
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
    [self setCurrentLevelLabel];
}

-(void)finished {
    if (!self.assertFailed) {
        self.size++;
        
        [UIView animateWithDuration:0.15 delay:0.1 options:0 animations:^{
            self.mazeView.mazeViewWalls.transform = CGAffineTransformMakeScale(1, 1);
            self.mazeView.mazeViewPath.transform = CGAffineTransformMakeScale(1, 1);
        } completion:^(BOOL f){
            [self.checkbox setOn:YES animated:YES];
            [UIView animateWithDuration:1 animations:^{
                self.mazeViewCenterConstraint.constant = -600;
                [self.view layoutIfNeeded];
            } completion:^(BOOL finished) {
                self.mazeViewCenterConstraint.constant = 600;
                [self.view layoutIfNeeded];
                [self recreateMaze];
                [self.checkbox setOn:NO animated:YES];
                [UIView animateWithDuration:1 animations:^{
                    self.mazeViewCenterConstraint.constant = 0;
                    [self.view layoutIfNeeded];
                } completion:nil];
            }];
        }];
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
            self.exitButton.alpha = 1;
        } completion:^(BOOL finished) {
            self.mazeView.delegate = nil;
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

- (void)setCurrentLevelLabel {
    self.currentLevelLabel.text = [NSString stringWithFormat:@"%d", self.size-1];
}

#pragma mark - iAd Delegates

- (void)setupAds {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"adState"]) {
        self.adBanner = [[ADBannerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        self.adBanner.backgroundColor = [UIColor clearColor];
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

@end
