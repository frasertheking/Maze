//
//  GameTypeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-04-20.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "GameTypeViewController.h"
#import "AppDelegate.h"
#import "HTPressableButton.h"
#import "UIColor+HTColor.h"
#import "StarBackgroundScene.h"

@interface GameTypeViewController ()

@property (nonatomic) HTPressableButton *rankedModeButton;
@property (nonatomic) HTPressableButton *casualModeButton;
@property (nonatomic) HTPressableButton *tutorialModeButton;
@property (nonatomic) HTPressableButton *challengeModeButton;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet SKView *particleView;

@end

@implementation GameTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)[AppDelegate getRandomColor].CGColor, (id)[AppDelegate getRandomColor].CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    self.rankedModeButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.rankedModeButton setTitle:@"Ranked" forState:UIControlStateNormal];
    self.rankedModeButton.center =  CGPointMake(self.view.center.x, self.view.center.y - 100);
    self.rankedModeButton.buttonColor = [UIColor ht_bitterSweetColor];
    self.rankedModeButton.shadowColor = [UIColor ht_bitterSweetDarkColor];
    [self.rankedModeButton addTarget:self action:@selector(rankedTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rankedModeButton];
    
    self.casualModeButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.casualModeButton setTitle:@"Casual" forState:UIControlStateNormal];
    self.casualModeButton.center = CGPointMake(self.view.center.x, self.view.center.y - 30);
    self.casualModeButton.buttonColor = [UIColor ht_lavenderColor];
    self.casualModeButton.shadowColor = [UIColor ht_lavenderDarkColor];
    [self.casualModeButton addTarget:self action:@selector(casualTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.casualModeButton];
    
    self.tutorialModeButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.tutorialModeButton setTitle:@"Tutorial" forState:UIControlStateNormal];
    self.tutorialModeButton.center =  CGPointMake(self.view.center.x, self.view.center.y + 40);
    self.tutorialModeButton.buttonColor = [UIColor ht_lemonColor];
    self.tutorialModeButton.shadowColor = [UIColor ht_lemonDarkColor];
    [self.tutorialModeButton addTarget:self action:@selector(tutorialTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.tutorialModeButton];
    
    self.challengeModeButton = [[HTPressableButton alloc] initWithFrame:CGRectMake(0, 0, 260, 50) buttonStyle:HTPressableButtonStyleRounded];
    [self.challengeModeButton setTitle:@"Challenge" forState:UIControlStateNormal];
    self.challengeModeButton.center =  CGPointMake(self.view.center.x, self.view.center.y + 110);
    self.challengeModeButton.buttonColor = [UIColor ht_wetAsphaltColor];
    self.challengeModeButton.shadowColor = [UIColor ht_midnightBlueColor];
    [self.challengeModeButton addTarget:self action:@selector(challengeTapped:)forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.challengeModeButton];
    [self setupParticles];
}

- (void)setupParticles {
    StarBackgroundScene* scene = [StarBackgroundScene sceneWithSize:self.particleView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleView.allowsTransparency = YES;
    [self.particleView presentScene:scene];
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

- (IBAction)rankedTapped:(id)sender {
    [self performSegueWithIdentifier:@"timedSegue" sender:self];
}

- (IBAction)casualTapped:(id)sender {
    [self performSegueWithIdentifier:@"casualSegue" sender:self];
}

- (IBAction)tutorialTapped:(id)sender {
    //[self performSegueWithIdentifier:@"tutorialSegue" sender:self];
    NSLog(@"TUTORIAL TAPPED");
}

- (IBAction)challengeTapped:(id)sender {
    //[self performSegueWithIdentifier:@"tutorialSegue" sender:self];
    NSLog(@"CHALLENGE TAPPED");
}

@end
