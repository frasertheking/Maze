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

@property (nonatomic) int size;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = 0;

    [self setupTextField];
    [self.mazeView setupGestureRecognizer:self.view];
    [self.mazeView initMazeWithSize:self.size];
    self.complexityLabel.text = [NSString stringWithFormat:@"%f", self.mazeView.complexity];
}

-(void) setupTextField {
    self.sizeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.sizeTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignTextField)];
    [self.view addGestureRecognizer:tapGesture];
}

#pragma mark - UITextViewDelegate

- (void)textFieldDidChange:(UITextField *)textField {
    if ([textField.text intValue] < 76) {
        self.size = [textField.text intValue];
        [self.mazeView initMazeWithSize:self.size];
        self.complexityLabel.text = [NSString stringWithFormat:@"%f", self.mazeView.complexity];
    } else {
        textField.text = 0;
    }
}

- (void)resignTextField {
    [self.sizeTextField resignFirstResponder];
}

#pragma mark - Actions

- (IBAction)randomizeMaze:(id)sender {
    [self.mazeView initMazeWithSize:self.size];
    self.complexityLabel.text = [NSString stringWithFormat:@"%f", self.mazeView.complexity];
}

- (IBAction)solveMaze:(id)sender {
    [self.mazeView solve];
}

- (IBAction)animateMaze:(id)sender {
    [self.mazeView transformMaze];
}

@end
