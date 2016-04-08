//
//  StarBackgroundScene.m
//  Maze
//
//  Created by Fraser King on 2016-04-08.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "StarBackgroundScene.h"

@implementation StarBackgroundScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor clearColor];
        NSString *emitterPath = [[NSBundle mainBundle] pathForResource:@"MazeBackgroundParticle" ofType:@"sks"];
        SKEmitterNode *bokeh = [NSKeyedUnarchiver unarchiveObjectWithFile:emitterPath];
        bokeh.position = CGPointMake(CGRectGetMidX(self.frame), self.size.height/2);
        bokeh.name = @"Bokeh";
        bokeh.targetNode = self.scene;
        [self addChild:bokeh];
    }
    return self;
}

@end
