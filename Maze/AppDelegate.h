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
#define GOLD UIColorFromRGB(0xFFD700)

#define SEVERITY_GREEN UIColorFromRGB(0x349940)
#define SEVERITY_YELLOW UIColorFromRGB(0xFFE15E)
#define SEVERITY_ORANGE UIColorFromRGB(0xFF912D)
#define SEVERITY_RED UIColorFromRGB(0xB6340D)

#define INVENTORY_PURPLE UIColorFromRGB(0xba54ff)
#define INVENTORY_RED UIColorFromRGB(0xe76154)
#define INVENTORY_BLUE UIColorFromRGB(0x0dccf3)
#define INVENTORY_GREEN UIColorFromRGB(0x9fdb36)
#define INVENTORY_ORANGE UIColorFromRGB(0xf4c04c)

#define FB_APP_ID 1688157554771031

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end

