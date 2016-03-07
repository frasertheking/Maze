//
//  ViewController.m
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "ViewController.h"
#import "DEMazeGenerator.h"

@interface ViewController ()

@property (nonatomic) int n;
@property (nonatomic) int m;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    int blocks = 10;
    
    self.n = blocks;
    self.m = blocks;
    
    NSInteger padding = 25;
    
    DEMazeGenerator *maze = [[DEMazeGenerator alloc] initWithRow:self.n
                                                          andCol:self.m
                                               withStartingPoint:DEIntegerPointMake(1, 1)];
    
    [maze arrayMaze:^(bool **item) {
        
        NSMutableString *rowString = [NSMutableString string];
        BOOL start = NO;
        BOOL end = NO;
        int min = 0;
        int max = self.n*2;
        
        for (int r = 0; r < self.n * 2 + 1 ; r++) {
            int rndValue = min + arc4random() % (max - min);
            for (int c = 0; c < self.m * 2 + 1 ; c++) {
                BOOL dontDraw = NO;
                if (r == 0 && !start && c == rndValue) {
                    if (item[r+1][c] != 1) {
                        dontDraw = YES;
                        start = YES;
                        rndValue = min + arc4random() % (max - min);
                    } else {
                        rndValue = min + arc4random() % (max - min);
                    }
                } else if (r == self.n*2 && !end && c == rndValue) {
                    if (item[r-1][c] != 1) {
                        dontDraw = YES;
                        end = YES;
                    } else {
                        rndValue = min + arc4random() % (max - min);
                    }
                }
                
                NSInteger size = (self.view.frame.size.width - padding * 2) / (self.m * 2 + 1);
                
                if (item[r][c] == 1 && !dontDraw) {
                    UIView *block = [[UIView alloc] initWithFrame:CGRectMake(r*size + padding, c*size + padding*3, size, size)];
                    block.backgroundColor = [self getRandomColor];
                    [self.view addSubview:block];
                }
            }
            
            NSLog(@"%@", rowString);
        }
        
    }];
    
}

-(UIColor*)getRandomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
