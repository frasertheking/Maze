//
//  ViewController.m
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "ViewController.h"
#import "DEMazeGenerator.h"

@interface ViewController ()

@property (nonatomic) int n;
@property (nonatomic) int m;
@property (nonatomic) NSMutableArray* blockArray;
@property (nonatomic) NSMutableArray* solArray;

@property (nonatomic) int startRow;
@property (nonatomic) int startCol;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self createMaze];
}

- (IBAction)randomizeMaze:(id)sender {
    [self createMaze];
}

- (void)createMaze {
    [self removeSubviews:1];
    [self removeSubviews:2];
    [self removeSubviews:3];
    
    int blocks = 20;
    
    self.n = blocks;
    self.m = blocks;
    
    NSInteger padding = 25;
    self.blockArray = [NSMutableArray arrayWithCapacity:blocks*2+1];
    self.solArray = [NSMutableArray arrayWithCapacity:blocks*2+1];
    for(int i=0; i<blocks*2+1; i++) {
        [self.blockArray addObject:[NSMutableArray arrayWithCapacity:blocks*2+1]];
    }
    for(int i=0; i<blocks*2+1; i++) {
        [self.solArray addObject:[NSMutableArray arrayWithCapacity:blocks*2+1]];
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
                
                NSInteger size = (self.view.frame.size.width - padding * 2) / (self.m * 2 + 1);
                BOOL first = YES;
                
                if (item[r][c] == 1 && !dontDraw) {
                    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*5, size, size)];
                    block.backgroundColor = [UIColor blueColor];
                    block.tag = 1;
                    block.alpha = 0.5;
                    [self.view addSubview:block];
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
            }
        }
        [self drawSolveLine];
        [self performSelector:@selector(solve) withObject:self afterDelay:0.5];
    }];
}

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
        [self drawSolveLine2];
        return YES;
    }
    
    if ([self isSafe:row y:column]) {
        [[self.solArray objectAtIndex:row] replaceObjectAtIndex:column withObject:[NSNumber numberWithInt:1]];
        //[self printArrayPretty:self.solArray];
        
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


-(void)drawSolveLine {
    NSInteger padding = 25;
    NSInteger size = (self.view.frame.size.width - padding * 2) / (self.m * 2 + 1);
    [self removeSubviews:2];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*5, size, size)];
                block.alpha = 0.5;
                block.backgroundColor = [UIColor redColor];
                block.tag = 2;
                [self.view addSubview:block];
            }
        }
    }
}

-(void)drawSolveLine2 {
    NSInteger padding = 25;
    NSInteger size = (self.view.frame.size.width - padding * 2) / (self.m * 2 + 1);
    [self removeSubviews:3];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.solArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*5, size, size)];
                block.alpha = 0.5;
                block.backgroundColor = [UIColor yellowColor];
                block.tag = 3;
                [self.view addSubview:block];
            }
        }
    }
}

- (void)removeSubviews:(NSInteger)tag {
    NSArray *viewsToRemove = [self.view subviews];
    for (UIView *v in viewsToRemove) {
        if (v.tag == tag) {
            [v removeFromSuperview];
        }
    }
}

-(UIColor*)getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
