//
//  PowerUpView.h
//  Maze
//
//  Created by Fraser King on 2016-04-04.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PowerUpView : UIView

typedef NS_ENUM(NSInteger, PowerUpType) {
    SlowTime,
    FreezeTime,
    ShowSolution,
    SolveLevel,
    PointsBoost,
    GodMode
};

@property (nonatomic) PowerUpType type;

- (id)initWithFrame:(CGRect)rect type:(PowerUpType)type;

@end
