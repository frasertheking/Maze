//
//  BonusTimeView.m
//  Maze
//
//  Created by Fraser King on 2016-04-17.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "BonusTimeView.h"

@interface BonusTimeView()

@property (nonatomic) UIImageView* backgroundImageView;

@end

@implementation BonusTimeView

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

- (void)initialize {
    self.backgroundColor = [UIColor clearColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    self.backgroundImageView.image = [UIImage imageNamed:@"hourglass"];
    [self addSubview:self.backgroundImageView];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.2];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.9];
    [self.backgroundImageView.layer addAnimation:scaleAnimation forKey:@"scale"];
}

@end
