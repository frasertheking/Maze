//
//  ViewController.m
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "ViewController.h"
#import "DEMazeGenerator.h"
#import "Maze.h"

@interface ViewController ()

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)randomizeMaze:(id)sender {
    [self.mazeView createMaze];
}

- (IBAction)solveMaze:(id)sender {
    [self.mazeView solve];
}

- (IBAction)animateMaze:(id)sender {
    [self.mazeView transformMaze];
}

@end
