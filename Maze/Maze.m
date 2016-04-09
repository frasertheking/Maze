//
//  Maze.m
//  Maze
//
//  Created by Fraser King on 2016-03-18.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "Maze.h"
#import "MazeViewController.h"
#import "PowerUpView.h"

@interface Maze ()

@property (nonatomic) int n;
@property (nonatomic) int m;
@property (nonatomic) int blocks;
@property (nonatomic) NSMutableArray* blockArray;
@property (nonatomic) NSMutableArray* solArray;
@property (nonatomic) NSMutableArray* attemptArray;

@property (nonatomic) CAGradientLayer* gradientLayer;
@property (nonatomic) int startRow;
@property (nonatomic) int startCol;
@property (nonatomic) NSTimer *gradientTimer;

@property NSInteger currentX;
@property NSInteger currentY;
@property CGPoint previousLoc;
@property NSInteger powerX;
@property NSInteger powerY;
@property NSInteger powerUpX;
@property NSInteger powerUpY;
@property NSInteger powerUpType;
@property BOOL power;
@property BOOL animate;
@property BOOL finished;
@property BOOL totalRandomColors;
@property double complexityScale;

@end

double rads = DEGREES_TO_RADIANS(180);

@implementation Maze

#pragma mark - initilization

- (id)initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        self.backgroundColor = [UIColor clearColor];
        self.mazeViewWalls = [[UIView alloc] initWithFrame:self.bounds];
        self.mazeViewWalls.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mazeViewWalls];
        
        self.mazeViewMask = [[UIView alloc] initWithFrame:self.bounds];
        self.mazeViewMask.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mazeViewMask];
        
        self.mazeViewRest = [[UIView alloc] initWithFrame:self.bounds];
        self.mazeViewRest.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mazeViewRest];
        
        self.mazeViewPath = [[UIView alloc] initWithFrame:self.bounds];
        self.mazeViewPath.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mazeViewPath];
        
        self.mazeViewPathMask= [[UIView alloc] initWithFrame:self.bounds];
        self.mazeViewPathMask.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mazeViewPathMask];
        
        self.mazeViewRandomColorWalls = [[UIView alloc] initWithFrame:self.bounds];
        self.mazeViewRandomColorWalls.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mazeViewRandomColorWalls];
        
        self.mazeSolveLine = [[UIView alloc] initWithFrame:self.bounds];
        self.mazeSolveLine.backgroundColor = [UIColor clearColor];
        [self addSubview:self.mazeSolveLine];
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
    if (self.n > 5) {
        self.power = NO;
    } else {
        self.power = NO;
    }
    
    if (self.n > 17) {
        self.complexityScale += 0.25;
        self.n -= 1;
        self.m -= 1;
    }
    
    if (self.n > 6) {
        self.animate = YES;
    } else {
        self.animate = NO;
    }
    
    if (self.n == 3) {
        self.totalRandomColors = YES;
    } else {
        self.totalRandomColors = NO;
    }
    
    if (self.n == 4 || self.n == 6) {
      //  [self transformMaze];
    }
    
    if (self.n > 10) {
        self.mazeViewWalls.alpha = 0.3;
    } else {
        self.mazeViewWalls.alpha = 1;
    }
    
    self.powerUpX = -1;
    self.powerUpY = -1;
    self.powerX = 1 + arc4random() % (self.n*2 - 1);
    self.powerY = 1 + arc4random() % (self.m*2 - 1);
    self.finished = NO;
    
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
    [self removeSubviews:self.mazeViewWalls];
    [self removeSubviews:self.mazeViewMask];
    [self removeSubviews:self.mazeViewRest];
    [self removeSubviews:self.mazeViewPath];
    [self removeSubviews:self.mazeViewPathMask];
    [self removeSubviews:self.mazeViewRandomColorWalls];
    [self removeSubviews:self.mazeSolveLine];
    [self.gradientTimer invalidate];
    self.gradientLayer = nil;
    [self.mazeViewPath.layer setSublayers:nil];
    [self.mazeViewWalls.layer setSublayers:nil];
    [self.mazeViewRest.layer setSublayers:nil];
    
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
    self.layer.shadowOffset = CGSizeMake(-2, 2);
    self.layer.shadowRadius = 2;
    self.layer.shadowOpacity = 0.1;
    
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
                    [self.mazeViewWalls addSubview:block];
                    block.backgroundColor = [UIColor whiteColor];
                    [self.mazeViewMask addSubview:block];
                    
                    if (self.totalRandomColors) {
                        block.backgroundColor = [self getRandomColor];
                        [self.mazeViewRandomColorWalls addSubview:block];
                    }
                    
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
        [self captureWalls];
        [self drawMazePaths];
        [self solve];
        [self captureAttemptPath];
        [self drawPowerups];
    }];
}

-(void)captureWalls {
    [self.gradientTimer invalidate];
    [self.mazeViewWalls.layer setSublayers:nil];
    self.gradientLayer = [CAGradientLayer layer];
    self.gradientLayer.frame = self.bounds;
    self.gradientLayer.colors = [NSArray arrayWithObjects:(id)[self inverseColor:(((MazeViewController*)self.delegate).mazeTopColor)].CGColor, (id)[self inverseColor:(((MazeViewController*)self.delegate).mazeBottomColor)].CGColor, nil];
    self.gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    self.gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    [self.mazeViewWalls.layer insertSublayer:self.gradientLayer atIndex:0];
    self.mazeViewWalls.maskView = self.mazeViewMask;
    
    if (self.animate) {
        [self animateWalls];
    }
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

-(void)showSolvePath {
    self.mazeSolveLine.hidden = NO;
}

#pragma mark - gestures

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint vel = [gestureRecognizer velocityInView:self];
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    NSInteger size = (self.frame.size.width) / (self.m * 2);
    if (!self.finished) {
        if (fabs(vel.x) > fabs(vel.y)) {
            if ([self distanceFrom:currentPoint to:self.previousLoc] >= (size / 1.5 + (1 / fabs(vel.x) * 150))) {
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
                        if (!self.finished) {
                            [[self.attemptArray objectAtIndex:self.currentX+1] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                            [self drawAttempt];
                            [((MazeViewController*)self.delegate) finished];
                            self.finished = YES;
                        }
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
            }
        } else {
            if ([self distanceFrom:currentPoint to:self.previousLoc] >= (size / 1.5 + (1 / fabs(vel.y) * 150))) {
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
        
        if (self.currentX == self.powerUpX && self.currentY == self.powerUpY) {
            self.powerUpY = -1;
            self.powerUpX = -1;
            [self removeSubviews:self.mazeViewRest];
            CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
            scaleAnimation.duration = 0.25;
            scaleAnimation.repeatCount = 0;
            scaleAnimation.autoreverses = YES;
            scaleAnimation.fromValue = [NSNumber numberWithFloat:1.0];
            scaleAnimation.toValue = [NSNumber numberWithFloat:1.15];
            [self.layer addAnimation:scaleAnimation forKey:@"scale"];
            [((MazeViewController*)self.delegate) itemFound:self.powerUpType];
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
    [self removeSubviews:self.mazeViewPath];
    [self removeSubviews:self.mazeViewPathMask];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.attemptArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                [self.mazeViewPath addSubview:block];
                block.backgroundColor = [UIColor whiteColor];
                [self.mazeViewPathMask addSubview:block];
            } else if ((r == 0 && ([[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1))) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                [self.mazeViewPath addSubview:block];
                block.backgroundColor = [UIColor whiteColor];
                [self.mazeViewPathMask addSubview:block];
            }
        }
    }
    [self captureAttemptPath];
}

-(void)captureAttemptPath {
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[self getRandomColor].CGColor, (id)[self getRandomColor].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    gradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    [self.mazeViewPath.layer insertSublayer:gradientLayer atIndex:0];
    self.mazeViewPath.maskView = self.mazeViewPathMask;
}

-(void)drawSolveLine {
    float size = (self.frame.size.width) / (self.m * 2 + 1);
    [self removeSubviews:self.mazeSolveLine];
    
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[self.solArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                block.alpha = 0.6;
                block.backgroundColor = SOLVE;
                [self.mazeSolveLine addSubview:block];
            }
        }
    }
    self.mazeSolveLine.hidden = YES;
}

-(void)drawMazePaths {
    float size = (self.frame.size.width) / (self.m * 2 + 1);

    [self removeSubviews:self.mazeViewPath];
    [self removeSubviews:self.mazeViewPathMask];
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ((r == 0 && ([[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1 || [[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 2))) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                block.backgroundColor = [self inverseColor:(((MazeViewController*)self.delegate).bottomColor)];
                [self.mazeViewPath addSubview:block];
                block.backgroundColor = [UIColor whiteColor];
                [self.mazeViewPathMask addSubview:block];
            } else if ([[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                block.backgroundColor = [UIColor clearColor];
                [self.mazeViewPath addSubview:block];
            }
        }
    }
}

-(void)drawPowerups {
    float size = (self.frame.size.width) / (self.m * 2 + 1);
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if (r >= self.powerX && c >= self.powerY && !self.power && [[[self.solArray objectAtIndex:r] objectAtIndex:c] integerValue] == 0 && [[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                self.powerUpType = arc4random() % 4;
                PowerUpView* powerUp = [[PowerUpView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size) type:self.powerUpType];
                self.power = YES;
                [self.mazeViewRest addSubview:powerUp];
                self.powerUpX = r;
                self.powerUpY = c;
            }
        }
    }
}

#pragma mark - helpers

- (void)removeSubviews:(UIView*)view {
    NSArray *viewsToRemove = [view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
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
    [UIView animateWithDuration:10 delay:0 options:(UIViewAnimationOptionAllowUserInteraction) animations:^{
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
    NSMutableArray *solArrayCopy = [self.solArray mutableCopy];
    for (int r = 0; r < self.n * 2 + 1 ; r++) {
        for (int c = 0; c < self.m * 2 + 1 ; c++) {
            if ([[[solArrayCopy objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                self.complexity++;
                [[solArrayCopy objectAtIndex:r] replaceObjectAtIndex:c withObject:[NSNumber numberWithInt:0]];
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
    
    return [[UIColor alloc] initWithRed:(componentColors[0] - 0.25) green:(componentColors[1] - 0.25) blue:(componentColors[2] - 0.25) alpha:componentColors[3] - 0.25];
}

- (UIColor *) getRandomColor {
    float golden_ratio_conjugate = 0.618033988749895;
    float h = (float)arc4random() / RAND_MAX;
    h += golden_ratio_conjugate;
    h = fmodf(h, 1.0);
    UIColor *tempColor = [UIColor colorWithHue:h saturation:0.8 brightness:0.95 alpha:1];
    return tempColor;
}

-(void)animateWalls {
    NSArray *fromColors = self.gradientLayer.colors;
    NSArray *toColors = @[(id)[self getRandomColor].CGColor,
                          (id)[self getRandomColor].CGColor,
                          (id)[self getRandomColor].CGColor,
                          (id)[self getRandomColor].CGColor,
                          (id)[self getRandomColor].CGColor,];
    
    [self.gradientLayer setColors:toColors];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.fromValue             = fromColors;
    animation.toValue               = toColors;
    animation.duration              = 1.00;
    animation.removedOnCompletion   = YES;
    animation.fillMode              = kCAFillModeForwards;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate              = self;
    
    [self.gradientLayer addAnimation:animation forKey:@"animateGradient"];
    self.gradientTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(animateWalls) userInfo:nil repeats:NO];
}

@end
