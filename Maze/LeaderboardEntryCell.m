//
//  LeaderboardEntryCell.m
//  Maze
//
//  Created by Fraser King on 2016-04-22.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "LeaderboardEntryCell.h"

@implementation LeaderboardEntryCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.imageCover.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageCover.layer.borderWidth = 1.0f;
}

@end
