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

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface Maze : UIView

-(void)createMaze;
-(void)solve;
-(void)transformMaze;
-(void)setupGestureRecognizer:(UIView*)view;
-(void)initMazeWithSize:(int)size;

@end
