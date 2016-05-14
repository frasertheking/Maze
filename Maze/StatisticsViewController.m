//
//  StatisticsViewController.m
//  Maze
//
//  Created by Fraser King on 2016-05-09.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "StatisticsViewController.h"
#import "AppDelegate.h"
#import "StarBackgroundScene.h"

@interface StatisticsViewController ()

@property (nonatomic, weak) IBOutlet UIButton *backButton;
@property (nonatomic, weak) IBOutlet SKView *particleView;
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *enemyNames;
@property (nonatomic) NSArray *matchHistory;

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)delegate.topColor.CGColor, (id)delegate.bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    self.enemyNames = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"enemyNames"]];
    self.matchHistory = [NSArray arrayWithArray:[[NSUserDefaults standardUserDefaults] arrayForKey:@"challengeMatchResults"]];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.allowsSelection = NO;

    [self setupParticles];
}

- (void)setupParticles {
    StarBackgroundScene* scene = [StarBackgroundScene sceneWithSize:self.particleView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleView.allowsTransparency = YES;
    [self.particleView presentScene:scene];
}

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

#pragma mark - UITableView Delegate and Datasource method implementation

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.enemyNames.count > 0) {
        return 4;
    } else {
        self.tableView.separatorColor = [UIColor clearColor];
        return 3;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else {
        return self.enemyNames.count;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 44)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(56, 0, tableView.frame.size.width, 44)];
    UIImageView *imageView;
    [label setFont:[UIFont boldSystemFontOfSize:17]];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    [view setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.01]];
    visualEffectView.frame = CGRectMake(0, 0, self.tableView.frame.size.width+10, 45);
    [view addSubview:visualEffectView];
    [visualEffectView addSubview:label];
    switch (section) {
        case 0:
            [label setText:@"Adventure Mode"];
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"adventure"]];
            break;
        case 1:
            [label setText:@"Ranked Mode"];
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ranked"]];
            break;
        case 2:
            [label setText:@"Casual Mode"];
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"casual"]];
            break;
        case 3:
            [label setText:@"Challenge Mode"];
            imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"challenge"]];
            break;
        default:
            break;
    }
    imageView.frame = CGRectMake(16, 10, 25, 25);
    [visualEffectView addSubview:imageView];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellIdentifier"];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = @"High Score:";
    cell.detailTextLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    
    switch (indexPath.section) {
        case 0:
            cell.textLabel.text = @"Current Level:";
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentLevel"]) {
                cell.detailTextLabel.text = [NSString stringWithFormat:@"%d", ([[[NSUserDefaults standardUserDefaults] stringForKey:@"currentLevel"] intValue] + 1)];
            } else {
                cell.detailTextLabel.text = @"0";
            }
            break;
        case 1:
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"rankedHighScore"]) {
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"rankedHighScore"];
            } else {
                cell.detailTextLabel.text = @"0";
            }
            break;
        case 2:
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"casualHighScore"]) {
                cell.detailTextLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"casualHighScore"];
            } else {
                cell.detailTextLabel.text = @"0";
            }
            break;
        case 3:
            cell.textLabel.text = [NSString stringWithFormat:@"Me vs. %@", self.enemyNames[indexPath.row]];
            cell.detailTextLabel.text = self.matchHistory[indexPath.row];
            if ([self.matchHistory[indexPath.row] isEqualToString:@"WON"]) {
                cell.detailTextLabel.textColor = SEVERITY_GREEN;
            } else if ([self.matchHistory[indexPath.row] isEqualToString:@"LOST"]) {
                cell.detailTextLabel.textColor = SEVERITY_RED;
            }
            break;
        default:
            break;
    }
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

@end
