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
    //[self createOrangeItem];
    //[self createBlueItem];
    //[self createPurpleItem];
    //[self createGreenItem];
    
    self.animatedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.animatedImageView.animationImages = self.imageArray;
    self.animatedImageView.animationDuration = 1;
    self.animatedImageView.alpha = 0.65;
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
}

- (void)createOrangeItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"orangeCrystal"];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"electricity_00y"],
                       [UIImage imageNamed:@"electricity_01y"],
                       [UIImage imageNamed:@"electricity_02y"],
                       [UIImage imageNamed:@"electricity_03y"],
                       [UIImage imageNamed:@"electricity_04y"],
                       [UIImage imageNamed:@"electricity_05y"],
                       [UIImage imageNamed:@"electricity_06y"],
                       [UIImage imageNamed:@"electricity_07y"],
                       [UIImage imageNamed:@"electricity_08y"],
                       [UIImage imageNamed:@"electricity_09y"],
                       [UIImage imageNamed:@"electricity_10y"],
                       [UIImage imageNamed:@"electricity_11y"],
                       [UIImage imageNamed:@"electricity_12y"],
                       [UIImage imageNamed:@"electricity_13y"],
                       [UIImage imageNamed:@"electricity_14y"],
                       [UIImage imageNamed:@"electricity_15y"],
                       [UIImage imageNamed:@"electricity_16y"],
                       [UIImage imageNamed:@"electricity_17y"],
                       [UIImage imageNamed:@"electricity_18y"],
                       [UIImage imageNamed:@"electricity_19y"],
                       [UIImage imageNamed:@"electricity_20y"],
                       [UIImage imageNamed:@"electricity_21y"],
                       [UIImage imageNamed:@"electricity_22y"],
                       [UIImage imageNamed:@"electricity_23y"],
                       [UIImage imageNamed:@"electricity_24y"],
                       [UIImage imageNamed:@"electricity_25y"],
                       [UIImage imageNamed:@"electricity_26y"],
                       [UIImage imageNamed:@"electricity_27y"],
                       [UIImage imageNamed:@"electricity_28y"],
                       [UIImage imageNamed:@"electricity_29y"],
                       [UIImage imageNamed:@"electricity_30y"],
                       [UIImage imageNamed:@"electricity_31y"],
                       [UIImage imageNamed:@"electricity_32y"],
                       [UIImage imageNamed:@"electricity_33y"],
                       nil];
}

- (void)createGreenItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"greenCrystal"];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"electricity_00g"],
                       [UIImage imageNamed:@"electricity_01g"],
                       [UIImage imageNamed:@"electricity_02g"],
                       [UIImage imageNamed:@"electricity_03g"],
                       [UIImage imageNamed:@"electricity_04g"],
                       [UIImage imageNamed:@"electricity_05g"],
                       [UIImage imageNamed:@"electricity_06g"],
                       [UIImage imageNamed:@"electricity_07g"],
                       [UIImage imageNamed:@"electricity_08g"],
                       [UIImage imageNamed:@"electricity_09g"],
                       [UIImage imageNamed:@"electricity_10g"],
                       [UIImage imageNamed:@"electricity_11g"],
                       [UIImage imageNamed:@"electricity_12g"],
                       [UIImage imageNamed:@"electricity_13g"],
                       [UIImage imageNamed:@"electricity_14g"],
                       [UIImage imageNamed:@"electricity_15g"],
                       [UIImage imageNamed:@"electricity_16g"],
                       [UIImage imageNamed:@"electricity_17g"],
                       [UIImage imageNamed:@"electricity_18g"],
                       [UIImage imageNamed:@"electricity_19g"],
                       [UIImage imageNamed:@"electricity_20g"],
                       [UIImage imageNamed:@"electricity_21g"],
                       [UIImage imageNamed:@"electricity_22g"],
                       [UIImage imageNamed:@"electricity_23g"],
                       [UIImage imageNamed:@"electricity_24g"],
                       [UIImage imageNamed:@"electricity_25g"],
                       [UIImage imageNamed:@"electricity_26g"],
                       [UIImage imageNamed:@"electricity_27g"],
                       [UIImage imageNamed:@"electricity_28g"],
                       [UIImage imageNamed:@"electricity_29g"],
                       [UIImage imageNamed:@"electricity_30g"],
                       [UIImage imageNamed:@"electricity_31g"],
                       [UIImage imageNamed:@"electricity_32g"],
                       [UIImage imageNamed:@"electricity_33g"],
                       nil];
}

- (void)createRedItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"redCrystal"];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"electricity_00r"],
                       [UIImage imageNamed:@"electricity_01r"],
                       [UIImage imageNamed:@"electricity_02r"],
                       [UIImage imageNamed:@"electricity_03r"],
                       [UIImage imageNamed:@"electricity_04r"],
                       [UIImage imageNamed:@"electricity_05r"],
                       [UIImage imageNamed:@"electricity_06r"],
                       [UIImage imageNamed:@"electricity_07r"],
                       [UIImage imageNamed:@"electricity_08r"],
                       [UIImage imageNamed:@"electricity_09r"],
                       [UIImage imageNamed:@"electricity_10r"],
                       [UIImage imageNamed:@"electricity_11r"],
                       [UIImage imageNamed:@"electricity_12r"],
                       [UIImage imageNamed:@"electricity_13r"],
                       [UIImage imageNamed:@"electricity_14r"],
                       [UIImage imageNamed:@"electricity_15r"],
                       [UIImage imageNamed:@"electricity_16r"],
                       [UIImage imageNamed:@"electricity_17r"],
                       [UIImage imageNamed:@"electricity_18r"],
                       [UIImage imageNamed:@"electricity_19r"],
                       [UIImage imageNamed:@"electricity_20r"],
                       [UIImage imageNamed:@"electricity_21r"],
                       [UIImage imageNamed:@"electricity_22r"],
                       [UIImage imageNamed:@"electricity_23r"],
                       [UIImage imageNamed:@"electricity_24r"],
                       [UIImage imageNamed:@"electricity_25r"],
                       [UIImage imageNamed:@"electricity_26r"],
                       [UIImage imageNamed:@"electricity_27r"],
                       [UIImage imageNamed:@"electricity_28r"],
                       [UIImage imageNamed:@"electricity_29r"],
                       [UIImage imageNamed:@"electricity_30r"],
                       [UIImage imageNamed:@"electricity_31r"],
                       [UIImage imageNamed:@"electricity_32r"],
                       [UIImage imageNamed:@"electricity_33r"],
                       nil];
}

- (void)createPurpleItem {
    self.backgroundImageView.image = [UIImage imageNamed:@"purpleCrystal"];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"electricity_00p"],
                       [UIImage imageNamed:@"electricity_01p"],
                       [UIImage imageNamed:@"electricity_02p"],
                       [UIImage imageNamed:@"electricity_03p"],
                       [UIImage imageNamed:@"electricity_04p"],
                       [UIImage imageNamed:@"electricity_05p"],
                       [UIImage imageNamed:@"electricity_06p"],
                       [UIImage imageNamed:@"electricity_07p"],
                       [UIImage imageNamed:@"electricity_08p"],
                       [UIImage imageNamed:@"electricity_09p"],
                       [UIImage imageNamed:@"electricity_10p"],
                       [UIImage imageNamed:@"electricity_11p"],
                       [UIImage imageNamed:@"electricity_12p"],
                       [UIImage imageNamed:@"electricity_13p"],
                       [UIImage imageNamed:@"electricity_14p"],
                       [UIImage imageNamed:@"electricity_15p"],
                       [UIImage imageNamed:@"electricity_16p"],
                       [UIImage imageNamed:@"electricity_17p"],
                       [UIImage imageNamed:@"electricity_18p"],
                       [UIImage imageNamed:@"electricity_19p"],
                       [UIImage imageNamed:@"electricity_20p"],
                       [UIImage imageNamed:@"electricity_21p"],
                       [UIImage imageNamed:@"electricity_22p"],
                       [UIImage imageNamed:@"electricity_23p"],
                       [UIImage imageNamed:@"electricity_24p"],
                       [UIImage imageNamed:@"electricity_25p"],
                       [UIImage imageNamed:@"electricity_26p"],
                       [UIImage imageNamed:@"electricity_27p"],
                       [UIImage imageNamed:@"electricity_28p"],
                       [UIImage imageNamed:@"electricity_29p"],
                       [UIImage imageNamed:@"electricity_30p"],
                       [UIImage imageNamed:@"electricity_31p"],
                       [UIImage imageNamed:@"electricity_32p"],
                       [UIImage imageNamed:@"electricity_33p"],
                       nil];
}

@end
