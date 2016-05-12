//
//  SettingsViewController.m
//  Maze
//
//  Created by Fraser King on 2016-04-24.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "StarBackgroundScene.h"

@interface SettingsViewController ()

@property (nonatomic, weak) IBOutlet UITableView* tableView;
@property (nonatomic, weak) IBOutlet UIButton* backButton;
@property (nonatomic, weak) IBOutlet SKView *particleView;
@property (nonatomic) NSMutableArray *settingNameArray;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.settingNameArray = [[NSMutableArray alloc] initWithObjects:@"Ads Enabled", @"Sounds Enabled", @"About", @"Feedback", @"Share", nil];
    
    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)delegate.topColor.CGColor, (id)delegate.bottomColor.CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.tableView setSeparatorColor:[[UIColor blackColor] colorWithAlphaComponent:0.5f]];
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self setupParticles];
}

- (void)setupParticles {
    StarBackgroundScene* scene = [StarBackgroundScene sceneWithSize:self.particleView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;
    self.particleView.allowsTransparency = YES;
    [self.particleView presentScene:scene];
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.settingNameArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    cell.textLabel.text = self.settingNameArray[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchview.tintColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    switch (indexPath.row) {
        case 0:
            [switchview addTarget:self action:@selector(setAdState:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchview;
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"adState"]) [switchview setOn:YES];
            break;
        case 1:
            [switchview addTarget:self action:@selector(setSoundState:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = switchview;
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"]) [switchview setOn:YES];
            break;
        default:
            cell.accessoryView = nil;
            break;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        [self performSegueWithIdentifier:@"showAboutSegue" sender:self];
    } else if (indexPath.row == 3) {        
        [self prepareFeedbackEmail];
    } else if (indexPath.row == 4) {
        [self share];
    }
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

#pragma mark - Helpers 

- (void)setAdState:(id)sender {
    BOOL state = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:state] forKey:@"adState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setSoundState:(id)sender {
    BOOL state = [sender isOn];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:state] forKey:@"soundState"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)prepareFeedbackEmail {
    MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
    mailCont.mailComposeDelegate = (id <MFMailComposeViewControllerDelegate>)self;
    [mailCont setSubject:@"CrazeMaze Feedback"];
    [mailCont setToRecipients:[NSArray arrayWithObjects:@"frasertheking@gmail.com",nil]];
    NSString *emailBody = [NSString stringWithFormat:@"\n\n\nSystem Diagnostics:\nModel: %@\nVersion: %@",
                           [UIDevice currentDevice].model,
                           [UIDevice currentDevice].systemVersion];
    [mailCont setMessageBody:emailBody isHTML:NO];
    [self presentViewController:mailCont animated:YES completion:nil];
}

- (void)share {
    NSString *text = @"Check out CrazeMaze, a new game by Frase! It has multiple game modes including a ranked mode which forces you to solve increasingly difficult mazes in short amounts of time. There are literally millions of mazes waiting for you to solve! Come check it out on the app store today!";
    UIImage *image = [UIImage imageNamed:@"Icon-60"];
    NSArray *activityItems = @[text, image];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypePrint, UIActivityTypePostToTwitter, UIActivityTypePostToWeibo];
    [self presentViewController:activityVC animated:TRUE completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error
{
    if(error) NSLog(@"ERROR - mailComposeController: %@", [error localizedDescription]);
    [self dismissViewControllerAnimated:YES completion:nil];
    return;
}

@end
