//
//  User.h
//  Maze
//
//  Created by Fraser King on 2016-04-23.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (nonatomic, strong) NSString* name;
@property (nonatomic) NSString* identifier;
@property (nonatomic) int score;
@property (nonatomic) NSString* picture;

- (id)initWithData:(NSDictionary*)data;

@end
