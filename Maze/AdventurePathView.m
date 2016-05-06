//
//  AdventurePathView.m
//  Maze
//
//  Created by Fraser King on 2016-05-05.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "AdventurePathView.h"

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

@end
