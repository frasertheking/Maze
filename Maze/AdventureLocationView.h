//
//  AdventureLocationView.h
//  Maze
//
//  Created by Fraser King on 2016-05-05.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdventureLocationView : UIView

@property (nonatomic) BOOL completed;
@property (nonatomic, weak) UIView* delegate;
@property (nonatomic) int level;

@end
