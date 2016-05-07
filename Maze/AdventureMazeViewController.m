//
//  AdventureMazeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-05-04.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "AdventureMazeViewController.h"
#import "StarBackgroundScene.h"
#import "AdventureLevelViewController.h"

@interface AdventureMazeViewController ()

@property (nonatomic, weak) IBOutlet UIView* contentView;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* contentViewHeightConstraint;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet SKView *particleView;
@property (nonatomic) int currentLevel;

@end

@implementation AdventureMazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentLevel = 1;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.path1.delegate = self;
    self.path2.delegate = self;
    self.path3.delegate = self;
    self.path4.delegate = self;
    self.path5.delegate = self;
    
    [self setGradientBackground];
    [self setupParticles];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.currentLevel = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"];
    [self updateForCurrentLevel];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    if (((self.contentView.frame.size.height * ((float)self.currentLevel / (float)100)) - 250) > (self.contentView.frame.size.height - self.view.frame.size.height)) {
        [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentSize.height - self.scrollView.bounds.size.height)];
    } else if (((self.contentView.frame.size.height * ((float)self.currentLevel / (float)100)) - 250) > 0) {
        [self.scrollView setContentOffset:CGPointMake(0, (self.contentView.frame.size.height * ((float)self.currentLevel / (float)100)) - 250)];
    }
}

- (void)updateForCurrentLevel {
    if (self.currentLevel > 20) {
        [self.path1 setAllLevelsComplete];
    } else {
        for (int i = 1; i < self.currentLevel; i++) {
            [self.path1 setLevelComplete:i];
        }
    }
    
    if (self.currentLevel > 40) {
        [self.path2 setAllLevelsComplete];
    } else {
        for (int i = 21; i < self.currentLevel; i++) {
            [self.path2 setLevelComplete:i % 20];
        }
    }
    
    if (self.currentLevel > 60) {
        [self.path3 setAllLevelsComplete];
    } else {
        for (int i = 41; i < self.currentLevel; i++) {
            [self.path3 setLevelComplete:i % 20];
        }
    }
    
    if (self.currentLevel > 80) {
        [self.path4 setAllLevelsComplete];
        for (int i = 81; i < self.currentLevel; i++) {
            [self.path5 setLevelComplete:i % 20];
        }
    } else {
        for (int i = 61; i < self.currentLevel; i++) {
            [self.path4 setLevelComplete:i % 20];
        }
    }
}

- (void)setupParticles {
    StarBackgroundScene* scene = [StarBackgroundScene sceneWithSize:self.particleView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleView.allowsTransparency = YES;
    [self.particleView presentScene:scene];
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AdventureLevelViewController *vc = [segue destinationViewController];
    vc.level = self.level;
}

-(void)dealloc {
    
}

#pragma mark - IBActions

- (IBAction)backPressed:(id)sender {
    [UIView animateWithDuration:0.15 animations:^{
        self.backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.backButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

@end
