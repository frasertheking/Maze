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
#import "LeaderboardEntryCell.h"
#import "User.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"

@interface LeaderboardViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIView *errorView;
@property (nonatomic, weak) IBOutlet UIButton *refreshButton;
@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, strong) NSMutableArray<User *> *users;

@end

@implementation LeaderboardViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.users = [[NSMutableArray alloc] init];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshViews];
}

- (void)setupViews {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)[AppDelegate getRandomColor].CGColor, (id)[AppDelegate getRandomColor].CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
}

- (void)getLeaderboardData {
    NSDictionary *params = @{@"access_token": [[FBSDKAccessToken currentAccessToken] tokenString], @"fields": @"user, score"};
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:[NSString stringWithFormat:@"/%ld/scores", FB_APP_ID] parameters:params  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        if (result) {
            for (id userData in [((NSDictionary*)result) objectForKey:@"data"]) {
                [self.users addObject:[[User alloc] initWithData:userData]];
            }
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [AppDelegate hideHUD:self.tableView];
        } else {
            NSLog(@"ERROR GETTING LEADERBOARD DATA");
        }
    }];
}

- (void)setupErrorView {
    self.errorView.hidden = NO;
    self.refreshButton.hidden = YES;
    self.errorView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
}

- (void)hideErrorView {
    self.errorView.hidden = YES;
    self.refreshButton.hidden = NO;
}

- (void)refreshViews {
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        [self getLeaderboardData];
        [AppDelegate showHUD:self.tableView];
        [self hideErrorView];
    } else {
        [self setupErrorView];
    }
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.users count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LeaderboardEntryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"leaderboardCell"];
    [cell.profilePicture sd_setImageWithURL:[NSURL URLWithString:self.users[indexPath.row].pictureUrl]
                      placeholderImage:[UIImage imageNamed:@"placeholder-user"]];
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld", (long)indexPath.row + 1];
    cell.name.text = self.users[indexPath.row].name;
    cell.score.text = [NSString stringWithFormat:@"%d", self.users[indexPath.row].score];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - IBActions

- (IBAction)backPressed:(id)sender {
    [UIView animateWithDuration:0.15 animations:^{
        self.backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.backButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (IBAction)refreshPressed:(id)sender {
    [UIView animateWithDuration:0.15 animations:^{
        self.refreshButton.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 animations:^{
            self.refreshButton.alpha = 1;
        } completion:^(BOOL finished) {
            [self.users removeAllObjects];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            [self getLeaderboardData];
            [AppDelegate showHUD:self.tableView];
        }];
    }];
}

@end
