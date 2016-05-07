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

@interface AdventureLocationView ()

@property (nonatomic) UILabel *levelLabel;

@end

@implementation AdventureLocationView

@synthesize completed = _completed;

- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    self.layer.borderWidth = 1;

    self.levelLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 20, 20)];
    self.levelLabel.textAlignment = NSTextAlignmentCenter;
    self.levelLabel.font = [UIFont systemFontOfSize:10];
    [self addSubview:self.levelLabel];
    
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
    self.levelLabel.text = [NSString stringWithFormat:@"%d", self.level];
}

- (void)updateBackgrounds {
    self.userInteractionEnabled = YES;
    if ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"] > (self.level-1)) {
        self.backgroundColor = SEVERITY_GREEN;
    } else if ([[NSUserDefaults standardUserDefaults] integerForKey:@"currentLevel"] == (self.level-1)) {
        self.backgroundColor = ORANGE;
    } else {
        self.backgroundColor = SEVERITY_YELLOW;
        self.userInteractionEnabled = NO;
    }
    self.levelLabel.text = [NSString stringWithFormat:@"%d", self.level];
}


- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    ((AdventurePathView*)self.delegate).level = self.level;
    [(AdventurePathView*)self.delegate segueToGame];
}

@end
