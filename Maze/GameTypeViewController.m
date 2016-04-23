//
//  GameTypeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-04-20.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "GameTypeViewController.h"
#import "AppDelegate.h"

@interface GameTypeViewController ()

@end

@implementation GameTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)[AppDelegate getRandomColor].CGColor, (id)[AppDelegate getRandomColor].CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
}

- (IBAction)timedTapped:(id)sender {
    [self performSegueWithIdentifier:@"timedSegue" sender:self];
}

- (IBAction)casualTapped:(id)sender {
    [self performSegueWithIdentifier:@"casualSegue" sender:self];
}

@end
