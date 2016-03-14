//
//  MazeCell.m
//  Maze
//
//  Created by Fraser King on 2016-03-12.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "MazeCell.h"

@implementation MazeCell

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.backgroundColor == [UIColor whiteColor]) {
        self.backgroundColor = [UIColor orangeColor];
    } else {
        self.backgroundColor = [UIColor whiteColor];
    }
}

@end
