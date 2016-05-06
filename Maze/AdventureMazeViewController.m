//
//  AdventureMazeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-05-04.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "AdventureMazeViewController.h"
#import "StarBackgroundScene.h"

@interface AdventureMazeViewController ()

@property (nonatomic, weak) IBOutlet UIView* contentView;
@property (nonatomic, weak) IBOutlet UIView* scrollView;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint* contentViewHeightConstraint;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet SKView *particleView;

@end

@implementation AdventureMazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    //self.contentViewHeightConstraint.constant = 2800;
    
    [self setGradientBackground];
    [self setupParticles];
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
