//
//  Maze.h
//  Maze
//
//  Created by Fraser King on 2016-03-18.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DEMazeGenerator.h"
#import "AppDelegate.h"

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface Maze : UIView

@property (nonatomic) UIViewController *delegate;
@property (nonatomic) UIView* mazeViewWalls;
@property (nonatomic) UIView* mazeViewMask;
@property (nonatomic) UIView* mazeViewRest;
@property (nonatomic) UIView* mazeViewBonusTime;
@property (nonatomic) UIView* mazeViewPath;
@property (nonatomic) UIView* mazeViewPathMask;
@property (nonatomic) UIView* mazeViewRandomColorWalls;
@property (nonatomic) UIView* mazeSolveLine;
@property (nonatomic) UIView* mazeViewEnemyPath;
@property (nonatomic) BOOL godMode;
@property (nonatomic) BOOL fadeOverTime;
@property (nonatomic) BOOL noTime;
@property (nonatomic) BOOL isCasualMode;
@property (nonatomic) BOOL isChallengeMode;
@property (nonatomic) BOOL isAdventureMode;
@property (nonatomic) NSNumber* seed;
@property NSInteger score;
@property (nonatomic) NSMutableArray* attemptArray;
@property BOOL powerOverwhelming;
@property BOOL power;
@property BOOL animate;
@property BOOL finished;
@property BOOL totalRandomColors;
@property BOOL reRandomize;
@property BOOL duality;
@property BOOL kaleidoscope;
@property BOOL pulse;
@property BOOL timeTreasureLevel;
@property BOOL showWhiteWall;
@property BOOL backgroundFlash;

-(void)createMaze;
-(void)solve;
-(void)transformMaze;
-(void)setupGestureRecognizer:(UIView*)view;
-(void)initMazeWithSize:(int)size;
-(void)showSolvePath;
-(void)showWhiteWalls;
-(void)activateGodMode;
-(void)drawOpponentAttempt:(NSArray*)array;
- (void)drawOpponentMove:(CGPoint)point;

@end
