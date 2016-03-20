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

@end

@implementation MazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = 0;

    [self setupTextField];
    [self.mazeView setupGestureRecognizer:self.view];
    [self.mazeView initMazeWithSize:self.size];
    self.complexityLabel.text = [NSString stringWithFormat:@"Complexity: %.02f", self.mazeView.complexity];
    
    self.topConstraint.constant = -150;
    self.bottomConstraint.constant = -150;
    self.showingOptions = NO;
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
        self.complexityLabel.text = [NSString stringWithFormat:@"Complexity: %.02f", self.mazeView.complexity];
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
    self.complexityLabel.text = [NSString stringWithFormat:@"Complexity: %.02f", self.mazeView.complexity];
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
