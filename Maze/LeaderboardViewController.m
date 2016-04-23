//
//  LeaderboardViewController.m
//  Maze
//
//  Created by Fraser King on 2016-04-22.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "LeaderboardViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "User.h"

@interface LeaderboardViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<User *> *users;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.users = [[NSMutableArray alloc] init];
    NSDictionary *params = @{
                             @"access_token": [[FBSDKAccessToken currentAccessToken] tokenString],
                             @"fields": @"user, score",
                             };
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/1688157554771031/scores"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (result) {
            for (id userData in [((NSDictionary*)result) objectForKey:@"data"]) {
                [self.users addObject:[[User alloc] initWithData:userData]];
            }
            NSLog(@"Users: %@", self.users);
        } else {
            NSLog(@"ERROR GETTING LEADERBOARD DATA");
        }
    }];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"myCell"];
    return cell;
}

@end
