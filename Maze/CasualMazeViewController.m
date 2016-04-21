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

@interface CasualMazeViewController ()

@property (nonatomic) int size;
@property (nonatomic) BOOL showingOptions;
@property (nonatomic) BOOL assertFailed;

@end

@implementation CasualMazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = 2;
    self.mazeView.isCasualMode = YES;
    
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
   
    [self setCurrentLevelLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    
    self.checkbox.tintColor = [UIColor clearColor];
    self.checkbox.onCheckColor = SOLVE;
    self.checkbox.onFillColor = SEVERITY_GREEN;
    self.checkbox.onTintColor = SOLVE;
    
    [self setupParticles];
    [self setupParallaxEffect];
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
    self.topColor = [self getRandomColor];
    self.bottomColor = [self getRandomColor];
    self.mazeTopColor = [self getRandomColor];
    self.mazeBottomColor = [self getRandomColor];
    self.lineTopColor = [self getRandomColor];
    self.lineBottomColor = [self getRandomColor];
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)self.topColor.CGColor, (id)self.bottomColor.CGColor, nil];
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

- (IBAction)back:(id)sender {
    NSLog(@"Back button pressed");
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

#pragma mark - Helpers

- (UIColor *) getRandomColor {
    float golden_ratio_conjugate = 0.618033988749895;
    float h = (float)arc4random() / RAND_MAX;
    h += golden_ratio_conjugate;
    h = fmodf(h, 1.0);
    UIColor *tempColor = [UIColor colorWithHue:h saturation:0.5 brightness:0.95 alpha:1];
    return tempColor;
}

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

@end
