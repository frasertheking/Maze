//
//  MazeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "MazeViewController.h"
#import "DEMazeGenerator.h"
#import "Maze.h"

@interface MazeViewController ()

@property (nonatomic) int size;
@property (nonatomic) BOOL showingOptions;
@property (nonatomic) NSTimer* timer;
@property (nonatomic) int remainingCounts;
@property (nonatomic) int score;

@end

@implementation MazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = 0;
    self.score = 0;

    [self setupTextField];
    self.mazeView.delegate = self;
    [self.mazeView setupGestureRecognizer:self.view];
    [self.mazeView initMazeWithSize:self.size];
    self.complexityLabel.text = [NSString stringWithFormat:@"Complexity: %.02f", self.mazeView.complexity];
    
    self.topConstraint.constant = -150;
    self.bottomConstraint.constant = -150;
    self.showingOptions = NO;
    
    [self setGradientBackground];
    [self setupParallaxEffect];
    [self resetCountdown];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)setupParallaxEffect {
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-15);
    verticalMotionEffect.maximumRelativeValue = @(15);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-15);
    horizontalMotionEffect.maximumRelativeValue = @(15);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [self.mazeView addMotionEffect:group];
}

-(void)setGradientBackground {
    UIColor *topColor = GRAY_LIGHT;
    UIColor *bottomColor = GRAY_DARK;
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)topColor.CGColor, (id)bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}

-(void) setupTextField {
    self.sizeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.sizeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextField)];
    [self.view addGestureRecognizer:tapGesture];
}

-(void)recreateMaze {    
    [self.mazeView initMazeWithSize:self.size];
    self.complexityLabel.text = [NSString stringWithFormat:@"Complexity: %.02f", self.mazeView.complexity];
    [self resetCountdown];
}

-(void)finished {
    self.score++;
    self.resultLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
}


#pragma mark - Countdown

-(void)resetCountdown {
    self.resultLabel.text = [NSString stringWithFormat:@"Score: %d", self.score];
    [self.timer invalidate];
    self.leadingTimerConstraint.constant = 40;
    self.trailingTimerConstraint.constant = 40;
    self.timerView.hidden = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1
                                                  target:self
                                                selector:@selector(countDown)
                                                userInfo:nil
                                                 repeats:YES];
    self.remainingCounts = (self.view.frame.size.width - 80) / 2;
}

-(void)countDown {
    self.leadingTimerConstraint.constant += 1;
    self.trailingTimerConstraint.constant += 1;
    
    if (self.remainingCounts > ((self.view.frame.size.width - 80) / 2)*0.75) {
        self.timerView.backgroundColor = SEVERITY_GREEN;
    } else if (self.remainingCounts > ((self.view.frame.size.width - 80) / 2)*0.5) {
        self.timerView.backgroundColor = SEVERITY_YELLOW;
    } else if (self.remainingCounts > ((self.view.frame.size.width - 80) / 2)*0.25){
        self.timerView.backgroundColor = SEVERITY_ORANGE;
    } else {
        self.timerView.backgroundColor = SEVERITY_RED;
    }
    
    if (--self.remainingCounts == 0) {
        [self.timer invalidate];
        self.resultLabel.text = @"Times up";
        self.score = 0;
        self.timerView.hidden = YES;
    }
}

#pragma mark - UITextViewDelegate

- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text intValue] < 76) {
        self.size = [textField.text intValue];
        [self.mazeView initMazeWithSize:self.size];
        self.complexityLabel.text = [NSString stringWithFormat:@"Complexity: %.02f", self.mazeView.complexity];
        [self resetCountdown];
    } else {
        textField.text = 0;
    }
}

- (void)resignTextField {
    [self.sizeTextField resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)randomizeMaze:(id)sender {
    self.score = 0;
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
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:0
                         animations:^{
                             self.topConstraint.constant = -150;
                             self.bottomConstraint.constant = -150;
                             self.showingOptions = NO;
                             [self.view layoutIfNeeded];
                         } completion:nil];
    } else {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:0
                         animations:^{
                             self.topConstraint.constant = 36;
                             self.bottomConstraint.constant = 16;
                             self.showingOptions = YES;
                             [self.view layoutIfNeeded];
                         } completion:nil];
    }
}

@end
