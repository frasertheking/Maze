//
//  AppDelegate.h
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ORANGE UIColorFromRGB(0xDC3522)
#define PALE UIColorFromRGB(0xD9CB9E)
#define GRAY_LIGHT UIColorFromRGB(0x374140)
#define GRAY_MED UIColorFromRGB(0x2A2C2B)
#define GRAY_DARK UIColorFromRGB(0x1E1E20)
#define SOLVE UIColorFromRGB(0x45BF55)

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

