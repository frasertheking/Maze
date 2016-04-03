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

@property (nonatomic) double complexity;
@property (nonatomic) UIViewController *delegate;
@property (nonatomic) UIView* mazeViewWalls;
@property (nonatomic) UIView* mazeViewMask;
@property (nonatomic) UIView* mazeViewRest;
@property (nonatomic) UIView* mazeViewPath;
@property (nonatomic) UIView* mazeViewPathMask;

-(void)createMaze;
-(void)solve;
-(void)transformMaze;
-(void)setupGestureRecognizer:(UIView*)view;
-(void)initMazeWithSize:(int)size;

@end
