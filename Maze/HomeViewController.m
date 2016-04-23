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

@interface HomeViewController ()

@property (nonatomic, weak) IBOutlet FBSDKLoginButton *loginButton;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    CAGradientLayer *theViewGradient = [CAGradientLayer layer];
    theViewGradient.colors = [NSArray arrayWithObjects: (id)[self getRandomColor].CGColor, (id)[self getRandomColor].CGColor, nil];
    theViewGradient.frame = self.view.bounds;
    [self.view.layer insertSublayer:theViewGradient atIndex:0];
    
    self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    self.loginButton.backgroundColor = [UIColor clearColor];
    
    if ([[FBSDKAccessToken currentAccessToken] hasGranted:@"publish_actions"]) {
        // For more complex open graph stories, use `FBSDKShareAPI`
        // with `FBSDKShareOpenGraphContent`
        NSDictionary *params = @{ @"score": @"3444",};
        /* make the API call */
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me/scores"
                                      parameters:params
                                      HTTPMethod:@"POST"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            NSLog(@"SCORE %@", result);
        }];
    } else {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logInWithPublishPermissions:@[@"publish_actions"]
                               fromViewController:self
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                              //TODO: process error or result.
                                          }];
    }
    
    // For more complex open graph stories, use `FBSDKShareAPI`
    // with `FBSDKShareOpenGraphContent`
    /* make the API call */
    NSDictionary *params = @{
                             @"access_token": [[FBSDKAccessToken currentAccessToken] tokenString],
                             };
    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                  initWithGraphPath:@"/me/scores"
                                  parameters:params
                                  HTTPMethod:@"GET"];
    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                          id result,
                                          NSError *error) {
        NSLog(@"%@", result);
    }];
}

- (UIColor *) getRandomColor {
    float golden_ratio_conjugate = 0.618033988749895;
    float h = (float)arc4random() / RAND_MAX;
    h += golden_ratio_conjugate;
    h = fmodf(h, 1.0);
    UIColor *tempColor = [UIColor colorWithHue:h saturation:0.5 brightness:0.95 alpha:1];
    return tempColor;
}

- (IBAction)playTapped:(id)sender {
    [self performSegueWithIdentifier:@"playSegue" sender:self];
}

- (IBAction)unwindToThisViewController:(UIStoryboardSegue *)unwindSegue {
    
}

@end
