//
//  AdventurePathView.m
//  Maze
//
//  Created by Fraser King on 2016-05-05.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "AdventurePathView.h"
#import "AdventureMazeViewController.h"

@implementation AdventurePathView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self addSubview:[[[NSBundle mainBundle] loadNibNamed:@"AdventurePathView" owner:self options:nil] objectAtIndex:0]];
        self.backgroundColor = [UIColor clearColor];
        [self setupViews];
    }
    return self;
}

-(void) setupViews {
    self.topLeftView.alpha = 0.6;
    self.middleView.alpha = 0.6;
    self.bottomRightView.alpha = 0.6;
    self.bottomView.alpha = 0.6;

    self.level1View.delegate = self;
    self.level1View.level = 1 + 20*self.pathNum;
    self.level2View.delegate = self;
    self.level2View.level = 2 + 20*self.pathNum;
    self.level3View.delegate = self;
    self.level3View.level = 3 + 20*self.pathNum;
    self.level4View.delegate = self;
    self.level4View.level = 4 + 20*self.pathNum;
    self.level5View.delegate = self;
    self.level5View.level = 5 + 20*self.pathNum;
    self.level6View.delegate = self;
    self.level6View.level = 6 + 20*self.pathNum;
    self.level7View.delegate = self;
    self.level7View.level = 7 + 20*self.pathNum;
    self.level8View.delegate = self;
    self.level8View.level = 8 + 20*self.pathNum;
    self.level9View.delegate = self;
    self.level9View.level = 9 + 20*self.pathNum;
    self.level10View.delegate = self;
    self.level10View.level = 10 + 20*self.pathNum;
    self.level11View.delegate = self;
    self.level11View.level = 11 + 20*self.pathNum;
    self.level12View.delegate = self;
    self.level12View.level = 12 + 20*self.pathNum;
    self.level13View.delegate = self;
    self.level13View.level = 13 + 20*self.pathNum;
    self.level14View.delegate = self;
    self.level14View.level = 14 + 20*self.pathNum;
    self.level15View.delegate = self;
    self.level15View.level = 15 + 20*self.pathNum;
    self.level16View.delegate = self;
    self.level16View.level = 16 + 20*self.pathNum;
    self.level17View.delegate = self;
    self.level17View.level = 17 + 20*self.pathNum;
    self.level18View.delegate = self;
    self.level18View.level = 18 + 20*self.pathNum;
    self.level19View.delegate = self;
    self.level19View.level = 19 + 20*self.pathNum;
    self.level20View.delegate = self;
    self.level20View.level = 20 + 20*self.pathNum;
    
    [self.level1View updateBackgrounds];
    [self.level2View updateBackgrounds];
    [self.level3View updateBackgrounds];
    [self.level4View updateBackgrounds];
    [self.level5View updateBackgrounds];
    [self.level6View updateBackgrounds];
    [self.level7View updateBackgrounds];
    [self.level8View updateBackgrounds];
    [self.level9View updateBackgrounds];
    [self.level10View updateBackgrounds];
    [self.level11View updateBackgrounds];
    [self.level12View updateBackgrounds];
    [self.level13View updateBackgrounds];
    [self.level14View updateBackgrounds];
    [self.level15View updateBackgrounds];
    [self.level16View updateBackgrounds];
    [self.level17View updateBackgrounds];
    [self.level18View updateBackgrounds];
    [self.level19View updateBackgrounds];
    [self.level20View updateBackgrounds];
}

-(void)setLevelComplete:(int)level {
    switch (level) {
        case 1:
            self.level1View.completed = YES;
            break;
        case 2:
            self.level2View.completed = YES;
            break;
        case 3:
            self.level3View.completed = YES;
            break;
        case 4:
            self.level4View.completed = YES;
            break;
        case 5:
            self.level5View.completed = YES;
            break;
        case 6:
            self.level6View.completed = YES;
            break;
        case 7:
            self.level7View.completed = YES;
            break;
        case 8:
            self.level8View.completed = YES;
            break;
        case 9:
            self.level9View.completed = YES;
            break;
        case 10:
            self.level10View.completed = YES;
            break;
        case 11:
            self.level11View.completed = YES;
            break;
        case 12:
            self.level12View.completed = YES;
            break;
        case 13:
            self.level13View.completed = YES;
            break;
        case 14:
            self.level14View.completed = YES;
            break;
        case 15:
            self.level15View.completed = YES;
            break;
        case 16:
            self.level16View.completed = YES;
            break;
        case 17:
            self.level17View.completed = YES;
            break;
        case 18:
            self.level18View.completed = YES;
            break;
        case 19:
            self.level19View.completed = YES;
            break;
        case 20:
            self.level20View.completed = YES;
            break;
        default:
            break;
    }
}

-(void)setAllLevelsComplete; {
    self.level1View.completed = YES;
    self.level2View.completed = YES;
    self.level3View.completed = YES;
    self.level4View.completed = YES;
    self.level5View.completed = YES;
    self.level6View.completed = YES;
    self.level7View.completed = YES;
    self.level8View.completed = YES;
    self.level9View.completed = YES;
    self.level10View.completed = YES;
    self.level11View.completed = YES;
    self.level12View.completed = YES;
    self.level13View.completed = YES;
    self.level14View.completed = YES;
    self.level15View.completed = YES;
    self.level16View.completed = YES;
    self.level17View.completed = YES;
    self.level18View.completed = YES;
    self.level19View.completed = YES;
    self.level20View.completed = YES;
}

-(void)reinitialize {
    [self setupViews];
}

- (void)segueToGame {
 //   ((AdventureMazeViewController*)self.delegate).level = self.level;
    [self.delegate performSegueWithIdentifier:@"adventureGameSegue" sender:self.delegate];
}

@end
