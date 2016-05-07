//
//  AdventureLevelViewController.m
//  Maze
//
//  Created by Fraser King on 2016-05-06.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "AdventureLevelViewController.h"
#import "DEMazeGenerator.h"
#import "Maze.h"
#import "StarBackgroundScene.h"
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"

@interface AdventureLevelViewController ()

@property (nonatomic) int size;
@property (nonatomic) int levelAchieved;
@property (nonatomic) BOOL showingOptions;
@property (nonatomic) BOOL assertFailed;
@property (nonatomic) NSTimer* timer;
@property (nonatomic) int remainingCounts;
@property (nonatomic) NSInteger itemType;
@property (nonatomic) int bonusTimesCollected;
@property (nonatomic) HTPressableButton *restartButton;
@property (nonatomic) HTPressableButton *leaderboardButton;
@property (nonatomic) FBSDKShareButton *shareButton;
@property (nonatomic) BOOL bannerIsVisible;
@property (nonatomic) ADBannerView *adBanner;

@end

@implementation AdventureLevelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = 10;
    self.itemType = -1;
    self.timeRemaining = 35;
    self.bonusTimesCollected = 0;
    
    [self setGradientBackground];
    self.mazeView.delegate = self;
    [self.mazeView setupGestureRecognizer:self.view];
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
    self.itemImage.alpha = 0;
    self.inventoryView.userInteractionEnabled = YES;
    self.timerView.userInteractionEnabled = NO;
    self.timerView.layer.borderWidth = 1.0f;
    self.timerView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.3].CGColor;
    self.inventoryView.alpha = 0;
    self.levelFailedView.alpha = 0;
    self.levelFailedView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.levelFailedView.layer.cornerRadius = 6;
    self.levelFailedView.layer.masksToBounds = YES;
    self.pictureCoverView.layer.borderColor = [UIColor blackColor].CGColor;
    self.pictureCoverView.layer.borderWidth = 1.0f;
    self.pictureCoverView.alpha = 0;
    [self.profilePictureImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [FBSDKAccessToken currentAccessToken].userID]] placeholderImage:[UIImage imageNamed:@"placeholder-user"]];
    self.restartButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.restartButton setTitle:@"Restart" forState:UIControlStateNormal];
    self.restartButton.center =  CGPointMake(self.levelFailedView.center.x - 150, self.levelFailedView.frame.size.height - 145);
    self.restartButton.buttonColor = [UIColor ht_grapeFruitColor];
    self.restartButton.shadowColor = [UIColor ht_grapeFruitDarkColor];
    [self.restartButton addTarget:self action:@selector(retryButtonClick:)forControlEvents:UIControlEventTouchUpInside];
    [self.levelFailedView addSubview:self.restartButton];
    
    self.leaderboardButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 200, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.leaderboardButton setTitle:@"Leaderboard" forState:UIControlStateNormal];
    self.leaderboardButton.center =  CGPointMake(self.levelFailedView.center.x - 150, self.levelFailedView.frame.size.height - 85);
    [self.leaderboardButton addTarget:self action:@selector(leaderboardButtonClick:)forControlEvents:UIControlEventTouchUpInside];
    [self.levelFailedView addSubview:self.leaderboardButton];
    
    self.shareButton = [[FBSDKShareButton alloc] init];
    self.shareButton.center =  CGPointMake(self.levelFailedView.center.x - 150, self.levelFailedView.frame.size.height - 35);
    [self.levelFailedView addSubview:self.shareButton];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useItem)];
    tapGesture.numberOfTapsRequired = 1;
    [self.inventoryView addGestureRecognizer:tapGesture];
    
    self.timerView.layer.cornerRadius = 6;
    self.timerView.layer.masksToBounds = YES;
    
    self.checkbox.tintColor = [UIColor clearColor];
    self.checkbox.onCheckColor = SOLVE;
    self.checkbox.onFillColor = SEVERITY_GREEN;
    self.checkbox.onTintColor = SOLVE;
    
    [self setupParticles];
    [self setupParallaxEffect];
    [self resetCountdown];
    [self setupAds];
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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
}

- (void)recreateMazeWithTimer {
    self.timerView.alpha = 1;
    [self recreateMaze];
}

-(void)finished {
    if (!self.assertFailed) {
        if (!self.mazeView.noTime) {
            if (self.size > 15) {
                self.timeRemaining = 15 + fabs(self.timer.fireDate.timeIntervalSinceNow) + 5*self.bonusTimesCollected;
            } else {
                self.timeRemaining = 10 + fabs(self.timer.fireDate.timeIntervalSinceNow) + 5*self.bonusTimesCollected;
            }
            self.mazeView.score += self.timeRemaining;
        }
        
        NSInteger highScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"highScore"];
        if (self.mazeView.score > highScore) {
            [[NSUserDefaults standardUserDefaults] setInteger:self.mazeView.score forKey:@"highScore"];
        }
        
        self.bonusTimesCollected = 0;

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
                    self.timerView.alpha = 1;
                    [self.view layoutIfNeeded];
                } completion:nil];
            }];
        }];
    }
}

#pragma mark - Countdown

-(void)resetCountdown {
    [self.timer invalidate];
    [self.timerView.layer removeAllAnimations];
    if (!self.mazeView.noTime) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeRemaining target:self selector:@selector(timesUp) userInfo:nil repeats:NO];
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale.x"];
        scaleAnimation.duration = self.timeRemaining + 0.25;
        scaleAnimation.repeatCount = 0;
        scaleAnimation.autoreverses = YES;
        scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
        scaleAnimation.toValue = [NSNumber numberWithFloat:0];
        [self.timerView.layer addAnimation:scaleAnimation forKey:@"scale"];
        
        self.timerView.backgroundColor = SEVERITY_GREEN;
        [UIView animateWithDuration:self.timeRemaining/3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.timerView.backgroundColor = SEVERITY_YELLOW;
        } completion:^(BOOL finished) {
            if (!finished) return;
            [UIView animateWithDuration:self.timeRemaining/3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.timerView.backgroundColor = SEVERITY_ORANGE;
            } completion:^(BOOL finished) {
                if (!finished) return;
                [UIView animateWithDuration:self.timeRemaining/3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                    self.timerView.backgroundColor = SEVERITY_RED;
                } completion:nil];
            }];
        }];
    }
}

-(void)timesUp {
    self.assertFailed = YES;
    [self.timer invalidate];
    self.timerView.alpha = 0;
    [self.timerView.layer removeAllAnimations];
    self.levelAchieved = self.size;
    [self levelFailed];
    self.size = 2;
}

-(void)freezeTime {
    //[self resetCountdown];
}

-(void)levelFailed {
    self.itemType = -1;
    self.timeRemaining = 10;
    self.itemImage.image = nil;
    self.inventoryView.alpha = 0;
    self.mazeView.score = 0;
    self.bonusTimesCollected = 0;
    self.mazeView.userInteractionEnabled = NO;
    [self runSpinAnimationOnView:self.mazeView duration:2 rotations:0.5 repeat:0];
    
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:@"https://frasertheking.com"];
    content.contentTitle = @"Check Out My CrazeMaze Score!";
    content.contentDescription = [NSString stringWithFormat:@"I just got to level %d on CrazeMaze! Think you can beat me?", self.levelAchieved-1];
    content.imageURL = [NSURL URLWithString:@"http://frasertheking.com/images/crazemazelogo.png"];
    self.shareButton.shareContent = content;
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        NSDictionary *params = @{@"access_token": [[FBSDKAccessToken currentAccessToken] tokenString], @"fields": @"user, score"};
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%@/scores", [FBSDKAccessToken currentAccessToken].userID] parameters:params  HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            BOOL newHighScore = NO;
            if (result) {
                if ([[[((NSDictionary*)result) objectForKey:@"data"] valueForKey:@"score"][0] intValue] < self.levelAchieved-1) {
                    newHighScore = YES;
                    NSDictionary *params = @{ @"score": [NSString stringWithFormat:@"%d", self.levelAchieved-1],};
                    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                                  initWithGraphPath:@"/me/scores"
                                                  parameters:params
                                                  HTTPMethod:@"POST"];
                    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                          id result,
                                                          NSError *error) {
                        NSLog(@"New High score: %@ %@", result, error);
                    }];
                }
                
                if (newHighScore) {
                    self.levelAchievedLabel.text = @"Congratulations";
                    self.highScoreLabel.text = [NSString stringWithFormat:@"New High Score: %d", self.levelAchieved-1];
                } else {
                    self.levelAchievedLabel.text = [NSString stringWithFormat:@"Level Achieved: %d", self.levelAchieved-1];
                    self.highScoreLabel.text = [NSString stringWithFormat:@"High Score: %d", [[[((NSDictionary*)result) objectForKey:@"data"] valueForKey:@"score"][0] intValue]];
                }
                [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                    self.mazeView.alpha = 0;
                    self.levelFailedView.alpha = 1;
                    self.pictureCoverView.alpha = 1;
                } completion:nil];
            }
        }];
    } else {
        self.levelAchievedLabel.text = [NSString stringWithFormat:@"Level Achieved: %d", self.levelAchieved-1];
        self.highScoreLabel.text = [NSString stringWithFormat:@"To see your high score, log in with facebook"];
        [UIView animateWithDuration:2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            self.mazeView.alpha = 0;
            self.levelFailedView.alpha = 1;
            self.pictureCoverView.alpha = 1;
        } completion:nil];
    }
}

-(void)bonusTimeFound {
    self.bonusTimesCollected++;
}

-(void)itemFound:(NSInteger)type {
    self.mazeView.score += 1000;
    switch (type) {
        case 0:
            self.itemImage.image = [UIImage imageNamed:@"redCrystal"];
            self.usePowerupLabel.text = @"Show Correct Path";
            self.inventoryView.backgroundColor = INVENTORY_RED;
            self.itemType = 0;
            break;
        case 1:
            self.itemImage.image = [UIImage imageNamed:@"blueCrystal"];
            self.usePowerupLabel.text = @"Reset Remaining Time";
            self.inventoryView.backgroundColor = INVENTORY_BLUE;
            self.itemType = 1;
            break;
        case 2:
            self.itemImage.image = [UIImage imageNamed:@"greenCrystal"];
            self.usePowerupLabel.text = @"Skip This Level";
            self.inventoryView.backgroundColor = INVENTORY_GREEN;
            self.itemType = 2;
            break;
        case 3:
            self.itemImage.image = [UIImage imageNamed:@"orangeCrystal"];
            self.usePowerupLabel.text = @"Activate God Mode";
            self.inventoryView.backgroundColor = INVENTORY_ORANGE;
            self.itemType = 3;
            break;
        default:
            self.itemImage.image = [UIImage imageNamed:@"purpleCrystal"];
            self.usePowerupLabel.text = @"Improve Visibility";
            self.inventoryView.backgroundColor = INVENTORY_PURPLE;
            self.itemType = 4;
            break;
    }
    
    self.itemImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    [UIView animateWithDuration:0.35 animations:^{
        self.inventoryView.alpha = 1;
        self.itemImage.alpha = 1;
        self.itemImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    } completion:^(BOOL finished) {
        [self runSpinAnimationOnView:self.itemImage duration:25 rotations:0.1 repeat:1];
        [self pulseView:self.itemImage];
    }];
}

- (void)useItem {
    if (self.itemType >= 0) {
        [self.itemImage.layer removeAllAnimations];
        switch (self.itemType) {
            case 0:
                [self.mazeView showSolvePath];
                break;
            case 1:
                [self freezeTime];
                break;
            case 2:
                [self finished];
                break;
            case 3:
                [self.mazeView activateGodMode];
                break;
            default:
                [self.mazeView showWhiteWalls];
                break;
        }
        self.itemType = -1;
        [UIView animateWithDuration:0.35 animations:^{
            self.itemImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 5, 5);
            self.itemImage.alpha = 0;
            self.inventoryView.alpha = 0;
        } completion:nil];
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

- (IBAction)retryButtonClick:(id)sender {
    [self recreateMazeWithTimer];
    self.mazeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    self.mazeView.userInteractionEnabled = YES;
    [self.mazeView.layer removeAllAnimations];
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.mazeView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        self.mazeView.alpha = 1;
        self.levelFailedView.alpha = 0;
        self.pictureCoverView.alpha = 0;
    } completion:nil];
}

- (IBAction)leaderboardButtonClick:(id)sender {
    [self performSegueWithIdentifier:@"showLeaderboardSegue" sender:self];
}

- (IBAction)exitGamePressed:(id)sender {
    [UIView animateWithDuration:0.15 animations:^{
        self.exitButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.exitButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self.timer invalidate];
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

#pragma mark - iAd Delegates

- (void)setupAds {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"adState"] == 1) {
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
    if (self.bannerIsVisible) {
        [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
        banner.frame = CGRectOffset(banner.frame, 0, banner.frame.size.height);
        [UIView commitAnimations];
        self.bannerIsVisible = NO;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    [self timesUp];
    return YES;
}

@end
