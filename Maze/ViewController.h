//
//  ViewController.h
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Maze.h"

@interface ViewController : UIViewController <UITextViewDelegate>

@property (nonatomic, weak) IBOutlet Maze *mazeView;
@property (nonatomic, weak) IBOutlet UITextField *sizeTextField;

@end

