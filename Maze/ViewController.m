//
//  ViewController.m
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "ViewController.h"
#import "DEMazeGenerator.h"
#import "MazeCell.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ViewController ()

@property (nonatomic) int n;
@property (nonatomic) int m;
@property (nonatomic) NSMutableArray* blockArray;
@property (nonatomic) NSMutableArray* solArray;
@property (nonatomic) NSMutableArray* attemptArray;
@property (nonatomic) UIView* previousPreviousView;
@property (nonatomic) UIView* previousView;

@property (nonatomic) int startRow;
@property (nonatomic) int startCol;

@property NSInteger currentX;
@property NSInteger currentY;
@property BOOL allowDraw;

@end

double rads = DEGREES_TO_RADIANS(180);

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.allowDraw = YES;
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [self.mazeView addGestureRecognizer:panGesture];
    [self createMaze];
}

- (void)createMaze {
    [self removeSubviews:1];
    [self removeSubviews:2];
    [self removeSubviews:3];
    [self removeSubviews:4];
        
    int blocks =  5 + arc4random() % (15 - 5);
    
    self.n = blocks;
    self.m = blocks;
    
    NSInteger padding = 0;
    self.blockArray = [NSMutableArray arrayWithCapacity:blocks*2+1];
    self.solArray = [NSMutableArray arrayWithCapacity:blocks*2+1];
    self.attemptArray = [NSMutableArray arrayWithCapacity:blocks*2+1];
    for(int i=0; i<blocks*2+1; i++) {
        [self.blockArray addObject:[NSMutableArray arrayWithCapacity:blocks*2+1]];
    }
    for(int i=0; i<blocks*2+1; i++) {
        [self.solArray addObject:[NSMutableArray arrayWithCapacity:blocks*2+1]];
    }
    for(int i=0; i<blocks*2+1; i++) {
        [self.attemptArray addObject:[NSMutableArray arrayWithCapacity:blocks*2+1]];
    }

    DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:self.n
                                                          andCol:self.m
                                               withStartingPoint:DEIntegerPointMake(1, 1)];
   
    [maze arrayMaze:^(bool **item) {
        
        BOOL start = NO;
        BOOL end = NO;
        int min = 1;
        int max = self.n*2;
        
        for (int r = 0; r < self.n * 2 + 1 ; r++) {
            int rndValue = min + arc4random() % (max - min);
            for (int c = 0; c < self.m * 2 + 1 ; c++) {
                
                BOOL dontDraw = NO;
                if (r == 0 && !start && c == rndValue) {
                    if (item[r+1][c] != 1) {
                        dontDraw = YES;
                        start = YES;
                        rndValue = min + arc4random() % (max - min);
                    } else {
                        rndValue++;
                    }
                } else if (r == self.n*2 && !end && c == rndValue) {
                    if (item[r-1][c] != 1) {
                        dontDraw = YES;
                        end = YES;
                    } else {
                        rndValue++;
                    }
                }
                
                NSInteger size = (self.mazeView.frame.size.width - padding * 2) / (self.m * 2);
                BOOL first = YES;
                
                if (item[r][c] == 1 && !dontDraw) {
                    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*5, size, size)];
                    block.backgroundColor = [UIColor blueColor];
                    block.tag = 1;
                    block.alpha = 0.5;
                    [self.mazeView addSubview:block];
                    [[self.blockArray objectAtIndex:r] insertObject:[NSNumber numberWithInt:0] atIndex:c];
                } else {
                    if (dontDraw) {
                        if (end) {
                            [[self.blockArray objectAtIndex:r] insertObject:[NSNumber numberWithInt:2] atIndex:c];
                        } else if (start) {
                            self.startRow = r;
                            self.startCol = c;
                            [[self.blockArray objectAtIndex:r] insertObject:[NSNumber numberWithInt:1] atIndex:c];
                            first = NO;
                        }
                    } else {
                        [[self.blockArray objectAtIndex:r] insertObject:[NSNumber numberWithInt:1] atIndex:c];
                    }
                }
                [[self.solArray objectAtIndex:r] insertObject:[NSNumber numberWithInt:0] atIndex:c];
                [[self.attemptArray objectAtIndex:r] insertObject:[NSNumber numberWithInt:0] atIndex:c];
            }
        }
        self.currentX = self.startRow;
        self.currentY = self.startCol;
        [self drawMazePaths];
    }];
}

#pragma mark - Maze Solving

-(void)solve {
    [self solveMaze:self.startRow column:self.startCol];
}

-(BOOL)isSafe:(NSInteger)x y:(NSInteger)y {
    if (x >= 0 && x < self.n*2 && y >= 0 && y < self.m*2 &&
        [[[self.solArray objectAtIndex:x] objectAtIndex:y] integerValue] != 1 &&
        [[[self.blockArray objectAtIndex:x] objectAtIndex:y] integerValue] == 1) {
        return YES;
    } else {
        return NO;
    }
}


-(BOOL)solveMaze:(NSInteger)row column:(NSInteger)column {
    if ([[[self.blockArray objectAtIndex:row] objectAtIndex:column] integerValue] == 2) {
        [[self.solArray objectAtIndex:row] replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:1]];
        [self drawSolveLine];
        return YES;
    }
    
    if ([self isSafe:row y:column]) {
        [[self.solArray objectAtIndex:row] replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:1]];
        
        if ([self solveMaze:(row + 1) column:column]) {
            return YES;
        }
        
        if ([self solveMaze:row column:(column + 1)]) {
            return YES;
        }
        
        if([self solveMaze:row column:column-1]) {
            return YES;
        }
        
        if([self solveMaze:row-1 column:column]) {
            return YES;
        }
        
        [[self.solArray objectAtIndex:row] replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:0]];
        return NO;
    }
    
    return NO;
}

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    
    CGPoint vel = [gestureRecognizer velocityInView:self.view];
    if (self.allowDraw) {
        if (fabs(vel.x) > fabs(vel.y)) {
            if (vel.x > 0) {
                NSLog(@"RIGHT");
                if (self.currentX + 1 < self.blockArray.count && [[[self.blockArray objectAtIndex:self.currentX+1] objectAtIndex:self.currentY] integerValue] == 1) {
                    self.currentX++;
                    if ([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:0]];
                    } else {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                    }
                }
            } else {
                NSLog(@"LEFT");
                if (self.currentX - 1 >= 0 && [[[self.blockArray objectAtIndex:self.currentX-1] objectAtIndex:self.currentY] integerValue] == 1) {
                    self.currentX--;
                    if ([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:0]];
                    } else {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                    }
                }
            }
        } else {
            if (vel.y < 0) {
                NSLog(@"UP");
                if (self.currentY - 1 >= 0 && [[[self.blockArray objectAtIndex:self.currentX] objectAtIndex:self.currentY-1] integerValue] == 1) {
                    self.currentY--;
                    if ([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:0]];
                    } else {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                    }
                }
            } else {
                NSLog(@"DOWN");
                if (self.currentY + 1 < self.blockArray.count && [[[self.blockArray objectAtIndex:self.currentX] objectAtIndex:self.currentY+1] integerValue] == 1) {
                    self.currentY++;
                    if ([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:0]];
                    } else {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                    }
                }
            }
        }
        [self stopDraw];
    }
    [self drawAttempt];
    [self printArrayPretty:self.attemptArray];
    
//    CGPoint draggingPoint = [gestureRecognizer locationInView:self.view];
//    UIView *hitView = [self.view hitTest:draggingPoint withEvent:nil];
//    NSInteger size = (self.mazeView.frame.size.width) / (self.m * 2);
//    
//    if (hitView.superview == self.view) {
//        hitView.center = draggingPoint;
//    } else if (hitView.tag == 2) {
//        if (hitView == self.previousPreviousView) {
//            [[self.attemptArray objectAtIndex:self.previousView.frame.origin.x / size] replaceObjectAtIndex:self.previousView.frame.origin.y / size withObject:[NSNumber numberWithInt:0]];
//            self.previousView.backgroundColor = [UIColor whiteColor];
//            self.previousPreviousView = nil;
//        } else if (hitView != self.previousView) {
//            if (hitView.backgroundColor == [UIColor whiteColor]) {
//                [[self.attemptArray objectAtIndex:hitView.frame.origin.x / size] replaceObjectAtIndex:hitView.frame.origin.y / size withObject:[NSNumber numberWithInt:1]];
//                hitView.backgroundColor = [UIColor orangeColor];
//            } else {
//                [[self.attemptArray objectAtIndex:hitView.frame.origin.x / size] replaceObjectAtIndex:hitView.frame.origin.y / size withObject:[NSNumber numberWithInt:0]];
//                hitView.backgroundColor = [UIColor whiteColor];
//            }
//            [self printArrayPretty:self.attemptArray];
//            self.previousPreviousView = self.previousView;
//            self.previousView = hitView;
//        }
//    }
}

-(void)stopDraw {
    self.allowDraw = NO;
    [NSTimer scheduledTimerWithTimeInterval:0.05
                                     target:self
                                   selector:@selector(drawable)
                                   userInfo:nil
                                    repeats:NO];
}

-(void)drawable {
    self.allowDraw = YES;
}

#pragma mark - Maze Drawing

-(void)drawAttempt {
    NSInteger padding = 0;
    NSInteger size = (self.mazeView.frame.size.width - padding * 2) / (self.m * 2);
    [self removeSubviews:4];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.attemptArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*5, size, size)];
                block.alpha = 0.5;
                block.backgroundColor = [UIColor orangeColor];
                block.tag = 4;
                [self.mazeView addSubview:block];
            }
        }
    }
}

-(void)drawSolveLine {
    NSInteger padding = 0;
    NSInteger size = (self.mazeView.frame.size.width - padding * 2) / (self.m * 2);
    [self removeSubviews:3];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.solArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*5, size, size)];
                block.alpha = 0.5;
                block.backgroundColor = [UIColor greenColor];
                block.tag = 3;
                [self.mazeView addSubview:block];
            }
        }
    }
}

-(void)drawMazePaths {
    NSInteger padding = 0;
    NSInteger size = (self.mazeView.frame.size.width - padding * 2) / (self.m * 2);
    [self removeSubviews:2];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ((r == 0 && [[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) || [[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 2) {
                MazeCell *block = [[MazeCell alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*5, size, size)];
                block.backgroundColor = [UIColor redColor];
                block.tag = 4;
                block.alpha = 0.5;
                [self.mazeView addSubview:block];
            } else if ([[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*5, size, size)];
                block.backgroundColor = [UIColor whiteColor];
                block.tag = 2;
                [self.mazeView addSubview:block];
            }
        }
    }
}

- (void)removeSubviews:(NSInteger)tag {
    NSArray *viewsToRemove = [self.mazeView subviews];
    for (UIView *v in viewsToRemove) {
        if (v.tag == tag) {
            [v removeFromSuperview];
        }
    }
}

#pragma mark - Helpers

-(void)printArrayPretty:(NSMutableArray*)array {
    NSMutableString *rowString = [NSMutableString string];
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        [rowString setString:[NSString stringWithFormat:@"%d: ", r]];
        
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            [rowString appendFormat:@"%@ ", [[[array objectAtIndex:c] objectAtIndex:r] integerValue] == 1 ? @"*" : @" "];
        }
        NSLog(@"%@", rowString);
    }
}

-(UIColor*)getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark - Actions

- (IBAction)randomizeMaze:(id)sender {
    [self createMaze];
}

- (IBAction)solveMaze:(id)sender {
    [self solve];
}

- (IBAction)animateMaze:(id)sender {
    [UIView animateWithDuration:5 delay:0 options:(UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.mazeView.layer.transform = CATransform3DMakeRotation(rads, 0, 0, 1);
    } completion:^(BOOL finished) {
        rads += DEGREES_TO_RADIANS(180);
    }];
}

@end
