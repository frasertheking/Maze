//
//  AdventureLocationView.m
//  Maze
//
//  Created by Fraser King on 2016-05-05.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "AdventureLocationView.h"
#import "Appdelegate.h"

@implementation AdventureLocationView

@synthesize completed = _completed;

- (void)initialize{
    self.backgroundColor = [UIColor clearColor];
    
   // if (self.completed) {
   //     self.backgroundColor = ORANGE;
   // } else {
        self.backgroundColor = PALE;
   // }

    self.layer.cornerRadius = self.frame.size.width / 2;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.6].CGColor;
    self.layer.borderWidth = 1;
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
    self.backgroundColor = ORANGE;
}

@end
