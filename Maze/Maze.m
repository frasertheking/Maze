//
//  Maze.m
//  Maze
//
//  Created by Fraser King on 2016-03-18.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "Maze.h"
#import "MazeViewController.h"

@interface Maze ()

@property (nonatomic) int n;
@property (nonatomic) int m;
@property (nonatomic) int blocks;
@property (nonatomic) NSMutableArray* blockArray;
@property (nonatomic) NSMutableArray* solArray;
@property (nonatomic) NSMutableArray* attemptArray;
@property (nonatomic) UIView* previousPreviousView;
@property (nonatomic) UIView* previousView;

@property (nonatomic) int startRow;
@property (nonatomic) int startCol;

@property NSInteger currentX;
@property NSInteger currentY;
@property CGPoint previousLoc;
@property NSInteger powerX;
@property NSInteger powerY;
@property BOOL power;
@property double complexityScale;

@end

double rads = DEGREES_TO_RADIANS(180);

@implementation Maze

#pragma mark - initilization

- (id)initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect{
    if(self = [super initWithFrame:rect]){

    }
    return self;
}

-(void)initMazeWithSize:(int)size {
    if (size > 2) {
        self.n = size;
        self.m = size;
        self.blocks = size;
    } else {
        self.n = 2;
        self.m = self.n;
        self.blocks = self.m;
    }
    self.complexity = 0;
    self.complexityScale = 0;
    if (self.n > 10) {
        self.power = NO;
    } else {
        self.power = YES;
    }
    
    if (self.n > 17) {
        self.complexityScale += 0.25;
        self.n -= 1;
        self.m -= 1;
    }
    
    self.powerX = 1 + arc4random() % (self.n*2 - 1);
    self.powerY = 1 + arc4random() % (self.m*2 - 1);
    
    [self initialize];
}

- (void)initialize {
    [self createMaze];
}

-(void)setupGestureRecognizer:(UIView*)view {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [view addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *resetTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasDoubleTapped:)];
    [resetTapGestureRecognizer setNumberOfTapsRequired:2];
    [view addGestureRecognizer:resetTapGestureRecognizer];
}

#pragma mark - generation

- (void)createMaze {
    [self removeSubviews:1];
    [self removeSubviews:2];
    [self removeSubviews:3];
    [self removeSubviews:4];
    [self removeSubviews:5];
    [self removeSubviews:6];
    
    self.blockArray = [NSMutableArray arrayWithCapacity:self.blocks*2+1];
    self.solArray = [NSMutableArray arrayWithCapacity:self.blocks*2+1];
    self.attemptArray = [NSMutableArray arrayWithCapacity:self.blocks*2+1];
    for(int i=0; i<self.blocks*2+1; i++) {
        [self.blockArray addObject:[NSMutableArray arrayWithCapacity:self.blocks*2+1]];
    }
    for(int i=0; i<self.blocks*2+1; i++) {
        [self.solArray addObject:[NSMutableArray arrayWithCapacity:self.blocks*2+1]];
    }
    for(int i=0; i<self.blocks*2+1; i++) {
        [self.attemptArray addObject:[NSMutableArray arrayWithCapacity:self.blocks*2+1]];
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
                
                float size = (self.frame.size.width) / (self.m * 2+1);
                BOOL first = YES;
                if (item[r][c] == 1 && !dontDraw) {
                    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                    block.backgroundColor = [self inverseColor:(((MazeViewController*)self.delegate).topColor)];
                    block.tag = 1;
                    block.alpha = 0.75;
                    [self addSubview:block];
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
        [self solve];
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
        if (self.complexity == 0) {
            [self calculateComplexity];
            if (self.complexity < self.n*self.complexityScale) {
                [self createMaze];
                return NO;
            }
        } else {
            [self drawSolveLine];
        }
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

#pragma mark - gestures

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint vel = [gestureRecognizer velocityInView:self];
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    NSInteger size = (self.frame.size.width) / (self.m * 2);
    
    if ([self distanceFrom:currentPoint to:self.previousLoc] >= (size / 1.5)) {
        if (fabs(vel.x) > fabs(vel.y)) {
            if (vel.x > 0) {
                if (self.currentX + 1 < self.blockArray.count && [[[self.blockArray objectAtIndex:self.currentX+1] objectAtIndex:self.currentY] integerValue] == 1) {
                    self.currentX++;
                    if ([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) {
                        [[self.attemptArray objectAtIndex:self.currentX-1] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:0]];
                    } else {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                    }
                    self.previousLoc = currentPoint;
                } else if (self.currentX + 1 < self.blockArray.count && [[[self.blockArray objectAtIndex:self.currentX+1] objectAtIndex:self.currentY] integerValue] == 2) {
                    [((MazeViewController*)self.delegate) finished];
                    [((MazeViewController*)self.delegate) recreateMaze];
                }
            } else {
                if (self.currentX - 1 > 0 && [[[self.blockArray objectAtIndex:self.currentX-1] objectAtIndex:self.currentY] integerValue] == 1) {
                    self.currentX--;
                    if ([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) {
                        [[self.attemptArray objectAtIndex:self.currentX+1] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:0]];
                    } else {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                    }
                }
                self.previousLoc = currentPoint;
            }
        } else {
            if (vel.y < 0) {
                if (self.currentY - 1 >= 0 && [[[self.blockArray objectAtIndex:self.currentX] objectAtIndex:self.currentY-1] integerValue] == 1) {
                    self.currentY--;
                    if ([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY+1 withObject:[NSNumber numberWithInt:0]];
                    } else {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                    }
                    self.previousLoc = currentPoint;
                }
            } else {
                if (self.currentY + 1 < self.blockArray.count && [[[self.blockArray objectAtIndex:self.currentX] objectAtIndex:self.currentY+1] integerValue] == 1) {
                    self.currentY++;
                    if ([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY-1 withObject:[NSNumber numberWithInt:0]];
                    } else {
                        [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                    }
                    self.previousLoc = currentPoint;
                }
            }
        }
    }
    [self drawAttempt];
    //[self printArrayPretty:self.attemptArray];
}

- (void)viewWasDoubleTapped:(UITapGestureRecognizer *)gestureRecognizer {
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.attemptArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                [[self.attemptArray objectAtIndex:r] replaceObjectAtIndex:c withObject:[NSNumber numberWithInt:0]];
            }
        }
    }
    self.currentX = self.startRow;
    self.currentY = self.startCol;
    [self drawAttempt];
}

#pragma mark - Maze Drawing

-(void)drawAttempt {
    float size = (self.frame.size.width) / (self.m * 2 + 1);
    [self removeSubviews:4];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.attemptArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                block.backgroundColor = [self inverseColor:(((MazeViewController*)self.delegate).bottomColor)];
                block.tag = 4;
                [self addSubview:block];
            }
        }
    }
}

-(void)drawSolveLine {
    float size = (self.frame.size.width) / (self.m * 2 + 1);
    [self removeSubviews:3];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.solArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                block.alpha = 0.5;
                block.backgroundColor = SOLVE;
                block.tag = 3;
                [self addSubview:block];
            }
        }
    }
}

-(void)drawMazePaths {
    float size = (self.frame.size.width) / (self.m * 2 + 1);

    [self removeSubviews:2];
    [self removeSubviews:5];
    [self removeSubviews:6];
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ((r == 0 && ([[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1 || [[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 2))) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                block.backgroundColor = [self inverseColor:(((MazeViewController*)self.delegate).bottomColor)];
                block.tag = 5;
                [self addSubview:block];
            } else if ([[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                if (r >= self.powerX && c >= self.powerY && !self.power) {
                    block.backgroundColor = [UIColor cyanColor];
                    block.alpha = 0.4;
                    block.tag = 6;
                    self.power = YES;
                } else {
                    block.backgroundColor = [UIColor clearColor];
                    block.tag = 2;
                }
                [self addSubview:block];
            }
        }
    }
}

#pragma mark - helpers

- (void)removeSubviews:(NSInteger)tag {
    NSArray *viewsToRemove = [self subviews];
    for (UIView *v in viewsToRemove) {
        if (v.tag == tag) {
            [v removeFromSuperview];
        }
    }
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

-(float)distanceFrom:(CGPoint)point1 to:(CGPoint)point2 {
    CGFloat xDist = (point2.x - point1.x);
    CGFloat yDist = (point2.y - point1.y);
    return sqrt((xDist * xDist) + (yDist * yDist));
}

-(void)transformMaze {
    [UIView animateWithDuration:5 delay:0 options:(UIViewAnimationOptionAllowUserInteraction) animations:^{
        self.layer.transform = CATransform3DMakeRotation(rads, 0, 0, 1);
    } completion:^(BOOL finished) {
        rads += DEGREES_TO_RADIANS(180);
    }];
}

-(void)setupArray:(NSMutableArray*)array {
    array = [NSMutableArray arrayWithCapacity:self.blocks*2+1];
    for(int i=0; i<self.blocks*2+1; i++) {
        [array addObject:[NSMutableArray arrayWithCapacity:self.blocks*2+1]];
    }
}

-(void)calculateComplexity {
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.solArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                self.complexity++;
                [[self.solArray objectAtIndex:r] replaceObjectAtIndex:c withObject:[NSNumber numberWithInt:0]];
            }
        }
    }
    self.complexity = self.complexity / self.blocks*2;
}

- (void) rotateImageView {
    [UIView animateWithDuration:1.0
                     animations:^
     {
         self.transform = CGAffineTransformMakeRotation(M_PI);
         self.transform = CGAffineTransformMakeRotation(0);
     }];
}

-(UIColor*) inverseColor:(UIColor*)color {
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    
    return [[UIColor alloc] initWithRed:(componentColors[0] - 0.45) green:(componentColors[1] - 0.45) blue:(componentColors[2] - 0.45) alpha:componentColors[3] - 0.2];
}

- (UIColor *) getRandomColor {
    float golden_ratio_conjugate = 0.618033988749895;
    float h = (float)arc4random() / RAND_MAX;
    h += golden_ratio_conjugate;
    h = fmodf(h, 1.0);
    UIColor *tempColor = [UIColor colorWithHue:h saturation:0.5 brightness:0.95 alpha:1];
    return tempColor;
}

@end
