//
//  AdventureMazeViewController.h
//  Maze
//
//  Created by Fraser King on 2016-05-04.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "AdventurePathView.h"

@interface AdventureMazeViewController : UIViewController

@property (nonatomic) UIColor* topColor;
@property (nonatomic) UIColor* bottomColor;
@property (nonatomic) UIColor* mazeTopColor;
@property (nonatomic) UIColor* mazeBottomColor;
@property (nonatomic) UIColor* lineTopColor;
@property (nonatomic) UIColor* lineBottomColor;

@property (nonatomic, weak) IBOutlet AdventurePathView* path1;
@property (nonatomic, weak) IBOutlet AdventurePathView* path2;
@property (nonatomic, weak) IBOutlet AdventurePathView* path3;
@property (nonatomic, weak) IBOutlet AdventurePathView* path4;
@property (nonatomic, weak) IBOutlet AdventurePathView* path5;
@property (nonatomic, weak) IBOutlet UILabel* currentLevelLabel;
@property (nonatomic) int level;

@end
