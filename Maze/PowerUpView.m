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
@property (nonatomic) UIImageView* animatedImageView;
@property (nonatomic) UIImageView* backgroundImageView;

@end

@implementation PowerUpView

- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.backgroundImageView.contentMode = UIViewContentModeScaleToFill;
    [self addSubview:self.backgroundImageView];

    [self createRedItem];
    
    self.animatedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.animatedImageView.animationImages = self.imageArray;
    self.animatedImageView.animationDuration = 1;
    [self addSubview:self.animatedImageView];
    [self.animatedImageView startAnimating];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.duration = 1;
    scaleAnimation.repeatCount = HUGE_VAL;
    scaleAnimation.autoreverses = YES;
    scaleAnimation.fromValue = [NSNumber numberWithFloat:1.1];
    scaleAnimation.toValue = [NSNumber numberWithFloat:0.9];
    [self.backgroundImageView.layer addAnimation:scaleAnimation forKey:@"scale"];
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

#pragma mark - Object Type

- (void)createBlueItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"blueCrystal"];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"electricity_00"],
                       [UIImage imageNamed:@"electricity_01"],
                       [UIImage imageNamed:@"electricity_02"],
                       [UIImage imageNamed:@"electricity_03"],
                       [UIImage imageNamed:@"electricity_04"],
                       [UIImage imageNamed:@"electricity_05"],
                       [UIImage imageNamed:@"electricity_06"],
                       [UIImage imageNamed:@"electricity_07"],
                       [UIImage imageNamed:@"electricity_08"],
                       [UIImage imageNamed:@"electricity_09"],
                       [UIImage imageNamed:@"electricity_10"],
                       [UIImage imageNamed:@"electricity_11"],
                       [UIImage imageNamed:@"electricity_12"],
                       [UIImage imageNamed:@"electricity_13"],
                       [UIImage imageNamed:@"electricity_14"],
                       [UIImage imageNamed:@"electricity_15"],
                       [UIImage imageNamed:@"electricity_16"],
                       [UIImage imageNamed:@"electricity_17"],
                       [UIImage imageNamed:@"electricity_18"],
                       [UIImage imageNamed:@"electricity_19"],
                       [UIImage imageNamed:@"electricity_20"],
                       [UIImage imageNamed:@"electricity_21"],
                       [UIImage imageNamed:@"electricity_22"],
                       [UIImage imageNamed:@"electricity_23"],
                       [UIImage imageNamed:@"electricity_24"],
                       [UIImage imageNamed:@"electricity_25"],
                       [UIImage imageNamed:@"electricity_26"],
                       [UIImage imageNamed:@"electricity_27"],
                       [UIImage imageNamed:@"electricity_28"],
                       [UIImage imageNamed:@"electricity_29"],
                       [UIImage imageNamed:@"electricity_30"],
                       [UIImage imageNamed:@"electricity_31"],
                       [UIImage imageNamed:@"electricity_32"],
                       [UIImage imageNamed:@"electricity_33"],
                       nil];
    self.animatedImageView.alpha = 0.85;
}

- (void)createOrangeItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"orangeCrystal"];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"ready_attack_00"],
                       [UIImage imageNamed:@"ready_attack_01"],
                       [UIImage imageNamed:@"ready_attack_02"],
                       [UIImage imageNamed:@"ready_attack_03"],
                       [UIImage imageNamed:@"ready_attack_04"],
                       [UIImage imageNamed:@"ready_attack_05"],
                       [UIImage imageNamed:@"ready_attack_06"],
                       [UIImage imageNamed:@"ready_attack_07"],
                       [UIImage imageNamed:@"ready_attack_08"],
                       [UIImage imageNamed:@"ready_attack_09"],
                       [UIImage imageNamed:@"ready_attack_10"],
                       [UIImage imageNamed:@"ready_attack_11"],
                       [UIImage imageNamed:@"ready_attack_12"],
                       [UIImage imageNamed:@"ready_attack_13"],
                       [UIImage imageNamed:@"ready_attack_14"],
                       [UIImage imageNamed:@"ready_attack_15"],
                       [UIImage imageNamed:@"ready_attack_16"],
                       [UIImage imageNamed:@"ready_attack_17"],
                       [UIImage imageNamed:@"ready_attack_18"],
                       [UIImage imageNamed:@"ready_attack_19"],
                       [UIImage imageNamed:@"ready_attack_20"],
                       [UIImage imageNamed:@"ready_attack_21"],
                       [UIImage imageNamed:@"ready_attack_22"],
                       [UIImage imageNamed:@"ready_attack_23"],
                       [UIImage imageNamed:@"ready_attack_24"],
                       nil];
    self.animatedImageView.alpha = 0.5;
}

- (void)createGreenItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"greenCrystal"];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"health_up_00"],
                       [UIImage imageNamed:@"health_up_01"],
                       [UIImage imageNamed:@"health_up_02"],
                       [UIImage imageNamed:@"health_up_03"],
                       [UIImage imageNamed:@"health_up_04"],
                       [UIImage imageNamed:@"health_up_05"],
                       [UIImage imageNamed:@"health_up_06"],
                       [UIImage imageNamed:@"health_up_07"],
                       [UIImage imageNamed:@"health_up_08"],
                       [UIImage imageNamed:@"health_up_09"],
                       [UIImage imageNamed:@"health_up_10"],
                       [UIImage imageNamed:@"health_up_11"],
                       [UIImage imageNamed:@"health_up_12"],
                       nil];
    self.animatedImageView.alpha = 0.5;
}

- (void)createRedItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"redCrystal"];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"explosion_2_00"],
                       [UIImage imageNamed:@"explosion_2_01"],
                       [UIImage imageNamed:@"explosion_2_02"],
                       [UIImage imageNamed:@"explosion_2_03"],
                       [UIImage imageNamed:@"explosion_2_04"],
                       [UIImage imageNamed:@"explosion_2_05"],
                       [UIImage imageNamed:@"explosion_2_06"],
                       [UIImage imageNamed:@"explosion_2_07"],
                       [UIImage imageNamed:@"explosion_2_08"],
                       nil];
    self.animatedImageView.alpha = 0.25;
}

@end
