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
@property (nonatomic) NSString *enemyName;
@property (nonatomic) int myScore;
@property (nonatomic) int enemyScore;
@property (nonatomic) NSString* messageString;
@property (nonatomic) NSInteger itemType;
-(void)didReceiveDataWithNotification:(NSNotification *)notification;

@end

@implementation ChallengeMazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.size = 10;
    self.gameOverButton.hidden = YES;
    self.myScore = 0;
    self.enemyScore = 0;
    
    [self setGradientBackground];
    self.mazeView.delegate = self;
    self.mazeView.isChallengeMode = YES;
    [self.mazeView setupGestureRecognizer:self.view];
    self.seed = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    self.mazeView.seed = self.seed;
    [self.mazeView initMazeWithSize:self.size];
    self.mazeView.score = 0;
    self.topConstraint.constant = -150;
    self.bottomConstraint.constant = -150;
    self.showingOptions = NO;
    self.mazeView.layer.cornerRadius = 10;
    self.mazeView.layer.masksToBounds = YES;
    self.mazeView.hidden = YES;
    self.messageString = [[NSString alloc] init];
    self.itemImage.alpha = 0;
    self.inventoryView.userInteractionEnabled = YES;
    self.inventoryView.alpha = 0;

    [self setupColors];
    [self hideScores];
    self.setupView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.setupView.layer.cornerRadius = 6;
    self.setupView.layer.masksToBounds = YES;
    self.findFriends.enabled = NO;
    [self.nameTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(useItem)];
    tapGesture.numberOfTapsRequired = 1;
    [self.inventoryView addGestureRecognizer:tapGesture];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [[self.appDelegate mcManager] setupPeerAndSessionWithDisplayName:[UIDevice currentDevice].name];
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

- (void)hideScores {
    self.playerScore1.hidden = YES;
    self.playerScore2.hidden = YES;
    self.playerScore3.hidden = YES;
    self.playerScore4.hidden = YES;
    self.playerScore5.hidden = YES;
    self.enemyScore1.hidden = YES;
    self.enemyScore2.hidden = YES;
    self.enemyScore3.hidden = YES;
    self.enemyScore4.hidden = YES;
    self.enemyScore5.hidden = YES;
    self.playerNameLabel.hidden = YES;
    self.enemyNameLabel.hidden = YES;
}

- (void)showScores {
    self.playerScore1.hidden = NO;
    self.playerScore2.hidden = NO;
    self.playerScore3.hidden = NO;
    self.playerScore4.hidden = NO;
    self.playerScore5.hidden = NO;
    self.enemyScore1.hidden = NO;
    self.enemyScore2.hidden = NO;
    self.enemyScore3.hidden = NO;
    self.enemyScore4.hidden = NO;
    self.enemyScore5.hidden = NO;
    self.playerNameLabel.hidden = NO;
    self.enemyNameLabel.hidden = NO;
}

- (void)setupColors {
    self.playerScore1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    self.playerScore2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    self.playerScore3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    self.playerScore4.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    self.playerScore5.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    
    self.enemyScore1.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    self.enemyScore2.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    self.enemyScore3.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    self.enemyScore4.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
    self.enemyScore5.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.15f];
}

- (void)updateScores {
    switch (self.myScore) {
        case 1:
            self.playerScore1.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        case 2:
            self.playerScore2.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        case 3:
            self.playerScore3.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        case 4:
            self.playerScore4.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        case 5:
            self.playerScore5.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        default:
            break;
    }
    
    switch (self.enemyScore) {
        case 1:
            self.enemyScore1.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        case 2:
            self.enemyScore2.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        case 3:
            self.enemyScore3.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        case 4:
            self.enemyScore4.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        case 5:
            self.enemyScore5.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.9f];
            break;
        default:
            break;
    }
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
    
    if (self.myScore == 4) {
        [self hideScores];
        [self.gameOverButton setTitle:@"YOU WIN" forState:UIControlStateNormal];
        self.gameOverButton.hidden = NO;
        self.mazeView.hidden = YES;
        self.inventoryView.hidden = YES;
    } else if (!self.assertFailed) {
        [self goInThree:@"Round won! Next level in:"];
        self.myScore++;
        self.playerNameLabel.text = [NSString stringWithFormat:@"%@", self.nameTextField.text];
        self.enemyNameLabel.text = [NSString stringWithFormat:@"%@", self.enemyName];
        [self updateScores];
        self.gameOverButton.hidden = NO;
        self.mazeView.hidden = YES;
        self.inventoryView.userInteractionEnabled = NO;
    }
}

#pragma mark - Items


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
            self.usePowerupLabel.text = @"Slow Opponent";
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
        [UIView animateWithDuration:0.35 animations:^{
            self.itemImage.transform = CGAffineTransformScale(CGAffineTransformIdentity, 5, 5);
            self.itemImage.alpha = 0;
            self.inventoryView.alpha = 0;
        } completion:^(BOOL finished) {
            switch (self.itemType) {
                case 0:
                    [self.mazeView showSolvePath];
                    break;
                case 1:
                    [self sendHideMaze];
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

-(void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text length] > 0) {
        self.findFriends.enabled = YES;
    } else {
        self.findFriends.enabled = NO;
    }
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

-(void)sendName{
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject: self.nameTextField.text];
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
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject: @"over"];
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

-(void)sendOpponentPoint:(CGPoint)point {
    NSData *dataToSend = [NSKeyedArchiver archivedDataWithRootObject: [NSValue valueWithCGPoint:point]];
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
            self.setupView.hidden = YES;
            self.gameOverButton.hidden = YES;
            self.mazeView.hidden = NO;
            self.mazeView.mazeViewMask.alpha = 1;
            self.inventoryView.userInteractionEnabled = YES;
            self.mazeView.userInteractionEnabled = YES;
            self.playerNameLabel.text = [NSString stringWithFormat:@"%@", self.nameTextField.text];
            self.enemyNameLabel.text = [NSString stringWithFormat:@"%@", self.enemyName];
            [self updateScores];
            self.mazeView.seed = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
            self.size++;
            [self.mazeView initMazeWithSize:self.size];
        });
    } else if ([dataType isKindOfClass:[NSValue class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSValue* value = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
            [self.mazeView drawOpponentMove:value.CGPointValue];
        });
    }
    else {
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
        } else if ([[NSKeyedUnarchiver unarchiveObjectWithData:receivedData] isEqualToString:@"over"]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mazeView.userInteractionEnabled = NO;
                
                if (self.enemyScore == 4) {
                    [self hideScores];
                    [self.gameOverButton setTitle:@"YOU LOST" forState:UIControlStateNormal];
                    self.gameOverButton.hidden = NO;
                    self.mazeView.hidden = YES;
                    self.inventoryView.hidden = YES;
                } else {                    
                    [self goInThree:@"Round Lost! Next level in:"];
                    self.enemyScore++;
                    self.playerNameLabel.text = [NSString stringWithFormat:@"%@", self.nameTextField.text];
                    self.enemyNameLabel.text = [NSString stringWithFormat:@"%@", self.enemyName];
                    [self updateScores];
                    self.gameOverButton.hidden = NO;
                    self.mazeView.hidden = YES;
                    self.inventoryView.userInteractionEnabled = NO;
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.enemyName = [NSKeyedUnarchiver unarchiveObjectWithData:receivedData];
                [self sendSeed];
            });
        }
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)goInThree:(NSString*)string {
    self.messageString = string;
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goInTwo) userInfo:nil repeats:NO];
    [self.gameOverButton setTitle:[NSString stringWithFormat:@"%@ 3", self.messageString] forState:UIControlStateNormal];
}

- (void)goInTwo {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goInOne) userInfo:nil repeats:NO];
    [self.gameOverButton setTitle:[NSString stringWithFormat:@"%@ 2", self.messageString] forState:UIControlStateNormal];
}


- (void)goInOne {
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(rematch) userInfo:nil repeats:NO];
    [self.gameOverButton setTitle:[NSString stringWithFormat:@"%@ 1", self.messageString] forState:UIControlStateNormal];
}


- (void)rematch {
    if (![self.messageString isEqualToString:@"Round Lost! Next level in:"]) {
        self.gameOverButton.hidden = YES;
        [self.gameOverButton setTitle:[NSString stringWithFormat:@"%@ 3", self.messageString] forState:UIControlStateNormal];
        self.mazeView.userInteractionEnabled = YES;
        self.seed = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
        self.mazeView.seed = self.seed;
        [self sendSeed];
        self.size++;
        [self.mazeView initMazeWithSize:self.size];
        self.mazeView.hidden = NO;
        self.inventoryView.userInteractionEnabled = YES;
        self.mazeView.mazeViewMask.alpha = 1;
    }
}

- (IBAction)browseForDevices:(id)sender {
    [[_appDelegate mcManager] advertiseSelf:YES];
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
                [self sendName];
                [self.mazeView initMazeWithSize:self.size];
                self.mazeView.hidden = NO;
                [self showScores];
                self.inventoryView.userInteractionEnabled = YES;
                self.mazeView.mazeViewMask.alpha = 1;
                [_appDelegate.mcManager.browser dismissViewControllerAnimated:YES completion:nil];
                [[_appDelegate mcManager] advertiseSelf:NO];
            });
        }
        else if (state == MCSessionStateNotConnected) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [[_appDelegate mcManager] advertiseSelf:YES];
                self.inventoryView.userInteractionEnabled = NO;
            });
        }
    }
}


@end
