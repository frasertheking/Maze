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

@end

@implementation MazeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.size = 0;

    [self setupTextField];
    self.mazeView.delegate = self;
    [self.mazeView setupGestureRecognizer:self.view];
    [self.mazeView initMazeWithSize:self.size];
    self.complexityLabel.text = [NSString stringWithFormat:@"Complexity: %.02f", self.mazeView.complexity];
    
    self.topConstraint.constant = -150;
    self.bottomConstraint.constant = -150;
    self.showingOptions = NO;
    
    self.view.backgroundColor = GRAY_DARK;
    self.mazeView.backgroundColor = GRAY_DARK;
    [self resetCountdown];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
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


#pragma mark - Countdown

-(void)resetCountdown {
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
        self.timerView.backgroundColor = [UIColor greenColor];
    } else if (self.remainingCounts > ((self.view.frame.size.width - 80) / 2)*0.5) {
        self.timerView.backgroundColor = [UIColor yellowColor];
    } else if (self.remainingCounts > ((self.view.frame.size.width - 80) / 2)*0.25){
        self.timerView.backgroundColor = [UIColor orangeColor];
    } else {
        self.timerView.backgroundColor = [UIColor redColor];
    }
    
    if (--self.remainingCounts == 0) {
        [self.timer invalidate];
        NSLog(@"YOU LOSE");
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
