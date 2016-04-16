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

@property (nonatomic) int mazeSize;
@property (nonatomic) NSMutableArray* blockArray;
@property (nonatomic) NSMutableArray* solArray;
@property (nonatomic) NSMutableArray* attemptArray;
@property (nonatomic) CAGradientLayer* wallsGradientLayer;
@property (nonatomic) CAGradientLayer* attemptPathGradientLayer;
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
@property BOOL powerOverwhelming;
@property BOOL power;
@property BOOL animate;
@property BOOL finished;
@property BOOL totalRandomColors;
@property BOOL reRandomize;
@property BOOL duality;
@property BOOL kaleidoscope;

@end

double rads = DEGREES_TO_RADIANS(180);

@implementation Maze

#pragma mark - initilization

- (id)initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect{
    if(self = [super initWithFrame:rect]){
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.mazeViewWalls = [[UIView alloc] initWithFrame:self.bounds];
    [self setupViews:self.mazeViewWalls];
    
    self.mazeViewMask = [[UIView alloc] initWithFrame:self.bounds];
    [self setupViews:self.mazeViewMask];
    
    self.mazeViewRest = [[UIView alloc] initWithFrame:self.bounds];
    [self setupViews:self.mazeViewRest];
    
    self.mazeViewRandomColorWalls = [[UIView alloc] initWithFrame:self.bounds];
    [self setupViews:self.mazeViewRandomColorWalls];
    
    self.mazeViewPath = [[UIView alloc] initWithFrame:self.bounds];
    [self setupViews:self.mazeViewPath];
    
    self.mazeViewPathMask= [[UIView alloc] initWithFrame:self.bounds];
    [self setupViews:self.mazeViewPathMask];
    
    self.mazeSolveLine = [[UIView alloc] initWithFrame:self.bounds];
    [self setupViews:self.mazeSolveLine];
}

- (void)setupViews:(UIView*)view {
    view.backgroundColor = [UIColor clearColor];
    [self addSubview:view];
}

-(void)initMazeWithSize:(int)size {
    int randomNum = arc4random() % 100;
    if ((randomNum == 1 || randomNum == 99) && size > 6) {
        self.mazeSize = 30;
        self.noTime = YES;
    } else {
        if (size > 2) {
            self.mazeSize = size;
        } else {
            self.mazeSize = 2;
        }
        
        // Stop growing maze size at this point
        if (self.mazeSize > 20) {
            self.mazeSize -= 1;
            self.mazeSize -= 1;
        }
        
        self.noTime = NO;
        [self generateMazeDistractions];
    }
    
    self.powerUpX = -1;
    self.powerUpY = -1;
    self.powerX = 1 + arc4random() % (self.mazeSize*2 - 1);
    self.powerY = 1 + arc4random() % (self.mazeSize*2 - 1);
    self.finished = NO;
    self.godMode = NO;
    
    [self createMaze];
}

- (void)generateMazeDistractions {
    int randomNum = arc4random() % 100;
    self.animate = NO;
    self.totalRandomColors = NO;
    self.reRandomize = NO;
    self.mazeViewWalls.alpha = 1;
    self.fadeOverTime = NO;
    self.duality = NO;
    self.kaleidoscope = NO;
    self.powerOverwhelming = NO;
    
    if (self.mazeSize > 6) {
        self.power = NO;
    
        if (randomNum >= 0 && randomNum < 10) {
            self.animate = YES;
        }
        
        if (randomNum >= 10 && randomNum < 20) {
            self.totalRandomColors = YES;
        }
        
        if (randomNum >= 20 && randomNum < 30) {
            [self performSelector:@selector(reRandomizeMaze) withObject:self afterDelay:4];
        }
        
        if (randomNum >= 30 && randomNum < 40) {
            self.mazeViewWalls.alpha = 0.4;
        }
        
        if (randomNum >= 40 && randomNum < 50) {
            self.fadeOverTime = YES;
        }
        
        if (randomNum >= 50 && randomNum < 55) {
            self.duality = YES;
        }
        
        if (randomNum >= 55 && randomNum < 60) {
            self.kaleidoscope = YES;
            [self performSelector:@selector(reRandomizeMaze) withObject:self afterDelay:4];
        }
        
        if (randomNum >= 60 && randomNum < 65) {
            self.animate = YES;
            self.mazeViewWalls.alpha = 0.4;
            self.fadeOverTime = YES;
        }
        
        if (randomNum >= 65 && randomNum < 68) {
            [self transform];
        }
        
        if (randomNum >= 68 && randomNum < 70) {
            [self performSelector:@selector(reRandomizeMaze) withObject:self afterDelay:4];
            [self performSelector:@selector(reRandomizeMaze) withObject:self afterDelay:8];
            [self performSelector:@selector(reRandomizeMaze) withObject:self afterDelay:12];
            self.fadeOverTime = YES;
        }
        
        if (randomNum >= 70 && randomNum < 73) {
            self.powerOverwhelming = YES;
        }
        
        if (randomNum >= 73 && randomNum < 78) {
            self.kaleidoscope = YES;
        }
    } else {
        self.power = YES;
    }
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
    self.wallsGradientLayer = nil;
    self.attemptPathGradientLayer = nil;
    [self.mazeViewPath.layer setSublayers:nil];
    [self.mazeViewWalls.layer setSublayers:nil];
    [self.mazeViewRest.layer setSublayers:nil];
    [self.mazeViewRandomColorWalls.layer setSublayers:nil];
    [self.mazeViewMask.layer setSublayers:nil];
    [self.mazeViewPathMask.layer setSublayers:nil];
    [self.layer removeAllAnimations];
    self.backgroundColor = [UIColor clearColor];

    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 6;
    //self.layer.shadowOffset = CGSizeMake(-2, 2);
    //self.layer.shadowRadius = 2;
    //self.layer.shadowOpacity = 0.1;
    self.mazeViewMask.alpha = 1;
    
    self.blockArray = [NSMutableArray arrayWithCapacity:self.mazeSize*2+1];
    self.solArray = [NSMutableArray arrayWithCapacity:self.mazeSize*2+1];
    self.attemptArray = [NSMutableArray arrayWithCapacity:self.mazeSize*2+1];
    for(int i=0; i<self.mazeSize*2+1; i++) {
        [self.blockArray addObject:[NSMutableArray arrayWithCapacity:self.mazeSize*2+1]];
    }
    for(int i=0; i<self.mazeSize*2+1; i++) {
        [self.solArray addObject:[NSMutableArray arrayWithCapacity:self.mazeSize*2+1]];
    }
    for(int i=0; i<self.mazeSize*2+1; i++) {
        [self.attemptArray addObject:[NSMutableArray arrayWithCapacity:self.mazeSize*2+1]];
    }
    
    DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:self.mazeSize
                                                          andCol:self.mazeSize
                                               withStartingPoint:DEIntegerPointMake(1, 1)];
    
    [maze arrayMaze:^(bool **item) {
        
        BOOL start = NO;
        BOOL end = NO;
        int min = 1;
        int max = self.mazeSize*2;
        
        for (int r = 0; r < self.mazeSize * 2 + 1 ; r++) {
            int rndValue = min + arc4random() % (max - min);
            for (int c = 0; c < self.mazeSize * 2 + 1 ; c++) {
                
                BOOL dontDraw = NO;
                if (r == 0 && !start && c == rndValue) {
                    if (item[r+1][c] != 1) {
                        dontDraw = YES;
                        start = YES;
                        rndValue = min + arc4random() % (max - min);
                    } else {
                        rndValue++;
                    }
                } else if (r == self.mazeSize*2 && !end && c == rndValue) {
                    if (item[r-1][c] != 1) {
                        dontDraw = YES;
                        end = YES;
                    } else {
                        rndValue++;
                    }
                }
                
                float size = (self.frame.size.width) / (self.mazeSize * 2+1);
                BOOL first = YES;
                if (item[r][c] == 1 && !dontDraw) {
                    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                    [self.mazeViewWalls addSubview:block];
                    block.backgroundColor = [UIColor whiteColor];
                    [self.mazeViewMask addSubview:block];
                    
                    if (self.totalRandomColors || self.kaleidoscope) {
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
        if (!self.reRandomize) {
            self.currentX = self.startRow;
            self.currentY = self.startCol;
        } else {
            self.reRandomize = NO;
        }
        [self captureWalls:NO];
        [self drawMazePaths];
        [self solve];
        [self captureAttemptPath];
        [self drawPowerups];
        
        if (self.fadeOverTime) {
            [UIView animateWithDuration:15 animations:^{
                self.mazeViewMask.alpha = 0.005;
            }];
        }
        
        if (self.powerOverwhelming) {
            [UIView animateWithDuration:0.1 animations:^{
                self.mazeViewMask.alpha = 0.005;
            }];
        }
    }];
}

#pragma mark - Maze Solving

-(void)solve {
    [self solveMaze:self.startRow column:self.startCol];
}

-(BOOL)isSafe:(NSInteger)x y:(NSInteger)y {
    if (x >= 0 && x < self.mazeSize*2 && y >= 0 && y < self.mazeSize*2 &&
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

#pragma mark - Gestures

- (void)panPiece:(UIPanGestureRecognizer *)gestureRecognizer {
    CGPoint vel = [gestureRecognizer velocityInView:self];
    CGPoint currentPoint = [gestureRecognizer locationInView:self];
    NSInteger size = (self.frame.size.width) / (self.mazeSize * 2);
    if (!self.finished) {
        if (fabs(vel.x) > fabs(vel.y)) {
            if ([self distanceFrom:currentPoint to:self.previousLoc] >= (size / 1.5 + (1 / fabs(vel.x) * 150))) {
                if (vel.x > 0) {
                    if (self.currentX + 1 < self.blockArray.count && [[[self.blockArray objectAtIndex:self.currentX+1] objectAtIndex:self.currentY] integerValue] == 2) {
                        if (!self.finished) {
                            [[self.attemptArray objectAtIndex:self.currentX+1] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                            [self drawAttempt];
                            self.score += 2 * self.mazeSize;
                            [((MazeViewController*)self.delegate) finished];
                            self.finished = YES;
                        }
                    } else if (self.currentX + 1 < self.blockArray.count && ([[[self.blockArray objectAtIndex:self.currentX+1] objectAtIndex:self.currentY] integerValue] == 1 || self.godMode)) {
                        self.currentX++;
                        if (([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) && !self.godMode) {
                            [[self.attemptArray objectAtIndex:self.currentX-1] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:0]];
                        } else {
                            [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                        }
                        self.previousLoc = currentPoint;
                    }
                } else {
                    if (self.currentX - 1 > 0 && ([[[self.blockArray objectAtIndex:self.currentX-1] objectAtIndex:self.currentY] integerValue] == 1 || self.godMode)) {
                        self.currentX--;
                        if (([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) && !self.godMode) {
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
                        if (self.currentY - 1 < self.blockArray.count && [[[self.blockArray objectAtIndex:self.currentX] objectAtIndex:self.currentY-1] integerValue] == 2) {
                            if (!self.finished) {
                                [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY-1 withObject:[NSNumber numberWithInt:1]];
                                [self drawAttempt];
                                [((MazeViewController*)self.delegate) finished];
                                self.finished = YES;
                            }
                        } else if (self.currentY - 1 >= 0 && ([[[self.blockArray objectAtIndex:self.currentX] objectAtIndex:self.currentY-1] integerValue] == 1 || self.godMode)) {
                            self.currentY--;
                            if (([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) && !self.godMode) {
                                [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY+1 withObject:[NSNumber numberWithInt:0]];
                            } else {
                                [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                            }
                            self.previousLoc = currentPoint;
                        }
                } else {
                    if (self.currentY + 1 < self.blockArray.count && [[[self.blockArray objectAtIndex:self.currentX] objectAtIndex:self.currentY+1] integerValue] == 2) {
                        if (!self.finished) {
                            [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY+1 withObject:[NSNumber numberWithInt:1]];
                            [self drawAttempt];
                            [((MazeViewController*)self.delegate) finished];
                            self.finished = YES;
                        }
                    } else if (self.currentY + 1 < self.blockArray.count && ([[[self.blockArray objectAtIndex:self.currentX] objectAtIndex:self.currentY+1] integerValue] == 1 || self.godMode)) {
                        self.currentY++;
                        if (([[[self.attemptArray objectAtIndex:self.currentX] objectAtIndex:self.currentY] integerValue] == 1) && !self.godMode) {
                            [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY-1 withObject:[NSNumber numberWithInt:0]];
                        } else {
                            [[self.attemptArray objectAtIndex:self.currentX] replaceObjectAtIndex:self.currentY withObject:[NSNumber numberWithInt:1]];
                        }
                        self.previousLoc = currentPoint;
                    }
                }
            }
        }
        
        // Check to see if we picked up a powerup
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

#pragma mark - Maze Drawing

-(void)drawAttempt {
    float size = (self.frame.size.width) / (self.mazeSize * 2 + 1);
    [self removeSubviews:self.mazeViewPath];
    [self removeSubviews:self.mazeViewPathMask];
    
    for (int r = 0; r < self.mazeSize * 2 + 1 ; r++) {
        for (int c = 0; c < self.mazeSize * 2 + 1 ; c++) {
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
    if (self.kaleidoscope) {
        [self captureWalls:NO];
    }
}

-(void)drawSolveLine {
    float size = (self.frame.size.width) / (self.mazeSize * 2 + 1);
    [self removeSubviews:self.mazeSolveLine];
    
    for (int r = 0; r < self.mazeSize * 2 + 1 ; r++) {
        for (int c = 0; c < self.mazeSize * 2 + 1 ; c++) {
            if ([[[self.solArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size)];
                block.alpha = 0.3;
                block.backgroundColor = SOLVE;
                [self.mazeSolveLine addSubview:block];
                self.score += 10;
            }
        }
    }
    self.mazeSolveLine.hidden = YES;
}

-(void)drawMazePaths {
    float size = (self.frame.size.width) / (self.mazeSize * 2 + 1);

    [self removeSubviews:self.mazeViewPath];
    [self removeSubviews:self.mazeViewPathMask];
    for (int r = 0; r < self.mazeSize * 2 + 1 ; r++) {
        for (int c = 0; c < self.mazeSize * 2 + 1 ; c++) {
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
    float size = (self.frame.size.width) / (self.mazeSize * 2 + 1);
    for (int r = 0; r < self.mazeSize * 2 + 1 ; r++) {
        for (int c = 0; c < self.mazeSize * 2 + 1 ; c++) {
            if ((self.powerOverwhelming && ([[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1 || [[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 2)) || (r >= self.powerX && c >= self.powerY && !self.power && [[[self.solArray objectAtIndex:r] objectAtIndex:c] integerValue] == 0 && [[[self.blockArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1)) {
                self.powerUpType = arc4random() % 5;
                PowerUpView* powerUp = [[PowerUpView alloc] initWithFrame:CGRectMake(r*size, c*size, size, size) type:self.powerUpType];
                self.power = YES;
                [self.mazeViewRest addSubview:powerUp];
                if (!self.powerOverwhelming) {
                    self.powerUpX = r;
                    self.powerUpY = c;
                }
            }
        }
    }
}

#pragma mark - Capture methods

-(void)captureAttemptPath {
    if (self.godMode) {
        [self.mazeViewPath.layer setSublayers:nil];
    }
    
    if (self.attemptPathGradientLayer == nil || self.godMode) {
        self.attemptPathGradientLayer = [CAGradientLayer layer];
        self.attemptPathGradientLayer.frame = self.bounds;
        self.attemptPathGradientLayer.colors = [NSArray arrayWithObjects:(id)[self getRandomColor].CGColor, (id)[self getRandomColor].CGColor, nil];
        self.attemptPathGradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
        self.attemptPathGradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
        [self.mazeViewPath.layer insertSublayer:self.attemptPathGradientLayer atIndex:0];
        self.mazeViewPath.maskView = self.mazeViewPathMask;
    }
}

-(void)captureWalls:(BOOL)white {
    [self.gradientTimer invalidate];
    [self.mazeViewWalls.layer setSublayers:nil];
    self.wallsGradientLayer = [CAGradientLayer layer];
    self.wallsGradientLayer.frame = self.bounds;
    if (self.kaleidoscope) {
        for (UIView *view in [self.mazeViewRandomColorWalls subviews]) {
            view.backgroundColor = [self getRandomColor];
        }
    } else if (self.duality) {
        self.wallsGradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, nil];
        if (self.totalRandomColors) {
            for (UIView *view in [self.mazeViewRandomColorWalls subviews]) {
                view.backgroundColor = [UIColor whiteColor];
            }
        }
        self.backgroundColor = [UIColor blackColor];
    } else if (white) {
        self.wallsGradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, nil];
        if (self.totalRandomColors) {
            for (UIView *view in [self.mazeViewRandomColorWalls subviews]) {
                view.backgroundColor = [UIColor whiteColor];
            }
        }
    } else if (self.godMode) {
        self.wallsGradientLayer.colors = [NSArray arrayWithObjects:(id)GOLD.CGColor, (id)GOLD.CGColor, nil];
    } else {
        self.wallsGradientLayer.colors = [NSArray arrayWithObjects:(id)[self inverseColor:(((MazeViewController*)self.delegate).mazeTopColor)].CGColor, (id)[self inverseColor:(((MazeViewController*)self.delegate).mazeBottomColor)].CGColor, nil];
    }
    self.wallsGradientLayer.startPoint = CGPointMake(0.0f, 0.0f);
    self.wallsGradientLayer.endPoint = CGPointMake(1.0f, 1.0f);
    [self.mazeViewWalls.layer insertSublayer:self.wallsGradientLayer atIndex:0];
    self.mazeViewWalls.maskView = self.mazeViewMask;
    
    if (self.duality) {
        [UIView animateWithDuration:10 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            self.backgroundColor = [UIColor whiteColor];
        } completion:nil];
        self.wallsGradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor whiteColor].CGColor, (id)[UIColor whiteColor].CGColor, nil];
        
        NSArray *fromColors = self.wallsGradientLayer.colors;
        NSArray *toColors = @[(id)[UIColor blackColor].CGColor,
                              (id)[UIColor blackColor].CGColor];
        
        [self.wallsGradientLayer setColors:toColors];
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
        
        animation.fromValue             = fromColors;
        animation.toValue               = toColors;
        animation.duration              = 10.00;
        animation.fillMode              = kCAFillModeForwards;
        animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        animation.delegate              = self;
        
        [self.wallsGradientLayer addAnimation:animation forKey:@"animateGradient"];
    }
    
    if (self.animate && !white && !self.godMode && !self.kaleidoscope) {
        [self animateWalls];
    }
}

#pragma mark - Ability helpers

-(void)showWhiteWalls {
    [self captureWalls:YES];
}

-(void)activateGodMode {
    self.godMode = YES;
    [self captureWalls:NO];
}

-(void)showSolvePath {
    self.mazeSolveLine.hidden = NO;
}

#pragma mark - helpers

- (void)removeSubviews:(UIView*)view {
    NSArray *viewsToRemove = [view subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
}

- (void)viewWasDoubleTapped:(UITapGestureRecognizer *)gestureRecognizer {
    for (int r = 0; r < self.mazeSize * 2 + 1 ; r++) {
        for (int c = 0; c < self.mazeSize * 2 + 1 ; c++) {
            if ([[[self.attemptArray objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                [[self.attemptArray objectAtIndex:r] replaceObjectAtIndex:c withObject:[NSNumber numberWithInt:0]];
            }
        }
    }
    self.currentX = self.startRow;
    self.currentY = self.startCol;
    [self drawAttempt];
}

-(void)printArrayPretty:(NSMutableArray*)array {
    NSMutableString *rowString = [NSMutableString string];
    for (int r = 0; r < self.mazeSize * 2 + 1 ; r++) {
        [rowString setString:[NSString stringWithFormat:@"%d: ", r]];
        
        for (int c = 0; c < self.mazeSize * 2 + 1 ; c++) {
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

-(void)calculateComplexity {
    NSMutableArray *solArrayCopy = [self.solArray mutableCopy];
    for (int r = 0; r < self.mazeSize * 2 + 1 ; r++) {
        for (int c = 0; c < self.mazeSize * 2 + 1 ; c++) {
            if ([[[solArrayCopy objectAtIndex:r] objectAtIndex:c] integerValue] == 1) {
                [[solArrayCopy objectAtIndex:r] replaceObjectAtIndex:c withObject:[NSNumber numberWithInt:0]];
            }
        }
    }
}

#pragma mark - Color methods

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
    NSArray *fromColors = self.wallsGradientLayer.colors;
    NSArray *toColors = @[(id)[self getRandomColor].CGColor,
                          (id)[self getRandomColor].CGColor,
                          (id)[self getRandomColor].CGColor,
                          (id)[self getRandomColor].CGColor,
                          (id)[self getRandomColor].CGColor,];
    
    [self.wallsGradientLayer setColors:toColors];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"colors"];
    
    animation.fromValue             = fromColors;
    animation.toValue               = toColors;
    animation.duration              = 1.00;
    animation.removedOnCompletion   = YES;
    animation.fillMode              = kCAFillModeForwards;
    animation.timingFunction        = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    animation.delegate              = self;
    
    [self.wallsGradientLayer addAnimation:animation forKey:@"animateGradient"];
    self.gradientTimer = [NSTimer scheduledTimerWithTimeInterval: 1 target:self selector:@selector(animateWalls) userInfo:nil repeats:NO];
}

-(void)setupGestureRecognizer:(UIView*)view {
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panPiece:)];
    [view addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *resetTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasDoubleTapped:)];
    [resetTapGestureRecognizer setNumberOfTapsRequired:2];
    [view addGestureRecognizer:resetTapGestureRecognizer];
}

- (void)reRandomizeMaze {
    self.reRandomize = YES;
    self.powerUpX = -1;
    self.powerUpY = -1;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * 1 * 1 ];
    rotationAnimation.duration = 0.5;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 0;
    
    [self.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [self performSelector:@selector(createMaze) withObject:self afterDelay:0.25];
}


@end
