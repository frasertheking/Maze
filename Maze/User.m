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
    
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                    initWithGraphPath:[NSString stringWithFormat:@"/%@/picture?type=large&redirect=false", self.identifier]
//                                    parameters:@{@"fields": @"data"}
//                                    HTTPMethod:@"GET"];
//      [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                            id result,
//                                            NSError *error) {
//          if (result) {
//              self.picture = result;
//          } else {
//              NSLog(@"ERROR GETTING PICTURE FOR %@ %@", self.name, error);
//          }
//      }];
    NSLog(@"user id: %@", self.identifier);

}

@end
