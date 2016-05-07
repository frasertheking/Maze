//
//  AdventureLocationView.m
//  Maze
//
//  Created by Fraser King on 2016-05-05.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "AdventureLocationView.h"
#import "AdventurePathView.h"
#import "Appdelegate.h"

@implementation AdventureLocationView

@synthesize completed = _completed;

- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    self.layer.borderWidth = 1;
    
    UITapGestureRecognizer *singleFingerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:singleFingerTap];
}

- (id)initWithCoder:(NSCoder *)aCoder{
    if(self = [super initWithCoder:aCoder]){
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)rect{
    if(self = [super initWithFrame:rect]){
        [self initialize];
    }
    return self;
}

- (void)setCompleted:(BOOL)completed {
    _completed = completed;
}

- (void)updateBackgrounds {
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"] > self.level ) {
        self.backgroundColor = SEVERITY_GREEN;
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"] == (self.level-1)) {
        self.backgroundColor = ORANGE;
    } else {
        self.backgroundColor = SEVERITY_YELLOW;
    }
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    ((AdventurePathView*)self.delegate).level = self.level;
    [(AdventurePathView*)self.delegate segueToGame];
}

@end
