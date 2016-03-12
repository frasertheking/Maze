//
//  MazeCell.m
//  Maze
//
//  Created by Fraser King on 2016-03-12.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "MazeCell.h"

@implementation MazeCell

-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor purpleColor];
    [self setNeedsDisplay];
}


@end
