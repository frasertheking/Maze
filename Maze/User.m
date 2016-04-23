//
//  User.m
//  Maze
//
//  Created by Fraser King on 2016-04-23.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "User.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@implementation User

- (id)initWithData:(NSDictionary*)dict {
    if (self = [super init]) {
        [self decodeData:dict];
    }
    return self;
}

- (void)decodeData:(NSDictionary*)dict {
    self.name = [[dict objectForKey:@"user"] valueForKey:@"name"];
    self.identifier = [[dict objectForKey:@"user"] valueForKey:@"id"];
    self.score = [[dict valueForKey:@"score"] intValue];
    self.pictureUrl = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", self.identifier];
}

@end
