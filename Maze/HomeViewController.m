//
//  HomeViewController.m
//  Maze
//
//  Created by Fraser King on 2016-04-20.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "HomeViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AppDelegate.h"

@interface HomeViewController ()

@property (nonatomic, weak) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)[AppDelegate getRandomColor].CGColor, (id)[AppDelegate getRandomColor].CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.publishPermissions = @[@"publish_actions"];
    self.loginButton.backgroundColor = [UIColor clearColor];
    
//    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
//        // For more complex open graph stories, use `FBSDKShareAPI`
//        // with `FBSDKShareOpenGraphContent`
//        NSDictionary *params = @{ @"score": @"1234",};
//        /* make the API call */
//        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
//                                      initWithGraphPath:@"/me/scores"
//                                      parameters:params
//                                      HTTPMethod:@"POST"];
//        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                              id result,
//                                              NSError *error) {
//            NSLog(@"SCORE %@", result);
//        }];
//    } else {
//        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//        [loginManager logInWithPublishPermissions:@[@"publish_actions"]
//                               fromViewController:self
//                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
//                                              //TODO: process error or result.
//                                          }];
//    }
    

}

- (IBAction)playTapped:(id)sender {
    [self performSegueWithIdentifier:@"playSegue" sender:self];
}

- (IBAction)leaderboardTapped:(id)sender {
    [self performSegueWithIdentifier:@"leaderboardSegue" sender:self];
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {
    
}

@end
