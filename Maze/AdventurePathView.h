//
//  AdventurePathView.h
//  Maze
//
//  Created by Fraser King on 2016-05-05.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdventureLocationView.h"

@interface AdventurePathView : UIView

@property (nonatomic, weak) IBOutlet UIView *topLeftView;
@property (nonatomic, weak) IBOutlet UIView *middleView;
@property (nonatomic, weak) IBOutlet UIView *bottomRightView;
@property (nonatomic, weak) IBOutlet UIView *bottomView;

@property (nonatomic, weak) IBOutlet AdventureLocationView *level1View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level2View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level3View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level4View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level5View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level6View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level7View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level8View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level9View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level10View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level11View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level12View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level13View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level14View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level15View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level16View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level17View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level18View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level19View;
@property (nonatomic, weak) IBOutlet AdventureLocationView *level20View;

@property (nonatomic) UIViewController* delegate;

-(void)setLevelComplete:(int)level;
-(void)setAllLevelsComplete;
-(void)segueToGame;

@end
