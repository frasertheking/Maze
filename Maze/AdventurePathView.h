//
//  AdventurePathView.h
//  Maze
//
//  Created by Fraser King on 2016-05-05.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdventurePathView : UIView

@property (nonatomic, weak) IBOutlet UIView *topLeftView;
@property (nonatomic, weak) IBOutlet UIView *middleView;
@property (nonatomic, weak) IBOutlet UIView *bottomRightView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@end
