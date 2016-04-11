//
//  PowerUpView.m
//  Maze
//
//  Created by Fraser King on 2016-04-04.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "PowerUpView.h"

@interface PowerUpView()

@property (nonatomic) NSArray* imageArray;
@property (nonatomic) UIImageView* backgroundImageView;

@end

@implementation PowerUpView

- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.backgroundImageView];

    switch (self.type) {
        case 0:
            [self createRedItem];
            break;
        case 1:
            [self createBlueItem];
            break;
        case 2:
            [self createGreenItem];
            break;
        case 3:
            [self createOrangeItem];
            break;
        default:
            [self createPurpleItem];
            break;
    }
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.33];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.9];
    [self.backgroundImageView.layer addAnimation:scaleAnimation forKey:@"scale"];
    [self runSpinAnimationOnView:self.backgroundImageView duration:25 rotations:0.1 repeat:1];
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

- (id)initWithFrame:(CGRect)rect type:(PowerUpType)type{
    if(self = [super initWithFrame:rect]){
        self.type = type;
        [self initialize];
    }
    return self;
}

#pragma mark - Helpers

- (void) runSpinAnimationOnView:(UIView*)view duration:(CGFloat)duration rotations:(CGFloat)rotations repeat:(float)repeat {
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 * rotations * duration ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = repeat;
    
    [view.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

#pragma mark - Object Type

- (void)createBlueItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"blueCrystal"];
}

- (void)createOrangeItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"orangeCrystal"];
}

- (void)createGreenItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"greenCrystal"];
}

- (void)createRedItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"redCrystal"];
}

- (void)createPurpleItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"purpleCrystal"];
}

@end
