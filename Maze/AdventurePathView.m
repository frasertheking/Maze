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

@end
