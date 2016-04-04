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

@end

@implementation PowerUpView

- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    self.imageArray = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"frame-1"],
                       [UIImage imageNamed:@"frame-2"],
                       [UIImage imageNamed:@"frame-3"],
                       [UIImage imageNamed:@"frame-4"],
                       [UIImage imageNamed:@"frame-5"],
                       [UIImage imageNamed:@"frame-6"],
                       [UIImage imageNamed:@"frame-7"],
                       [UIImage imageNamed:@"frame-8"],
                       [UIImage imageNamed:@"frame-9"],
                       [UIImage imageNamed:@"frame-10"],
                       nil];
    self.animatedImageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.animatedImageView.animationImages = self.imageArray;
    self.animatedImageView.animationDuration = 1;
    [self addSubview:self.animatedImageView];
    [self.animatedImageView startAnimating];
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

@end
