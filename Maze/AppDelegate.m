//
//  AppDelegate.m
//  Maze
//
//  Created by Fraser King on 2016-02-28.
//  Copyright © 2016 Fraser King. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@property (nonatomic, strong) AVAudioPlayer *backgroundPlayer;
@property (nonatomic, strong) AVAudioPlayer *additionalSoundPlayer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"firstRun"]) {
        [[NSUserDefaults standardUserDefaults] setObject:[NSDate date] forKey:@"firstRun"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"adState"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"soundState"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0] forKey:@"currentLevel"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:NULL];
    
    self.topColor = [self getRandomColor];
    self.bottomColor = [self getRandomColor];
    self.mcManager = [[MCManager alloc] init];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application openURL:url sourceApplication:sourceApplication annotation:annotation];
    return handled;
}

#pragma mark - Global Helpers

+ (UIColor *) getRandomColor {
    float golden_ratio_conjugate = 0.618033988749895;
    float h = (float)arc4random() / RAND_MAX;
    h += golden_ratio_conjugate;
    h = fmodf(h, 1.0);
    UIColor *tempColor = [UIColor colorWithHue:h saturation:0.5 brightness:0.95 alpha:1];
    return tempColor;
}

+(UIColor*)inverseColor:(UIColor*)color {
    const CGFloat *componentColors = CGColorGetComponents(color.CGColor);
    return [[UIColor alloc] initWithRed:(componentColors[0] - 0.25) green:(componentColors[1] - 0.25) blue:(componentColors[2] - 0.25) alpha:componentColors[3] - 0.25];
}


- (UIColor *) getRandomColor {
    float golden_ratio_conjugate = 0.618033988749895;
    float h = (float)arc4random() / RAND_MAX;
    h += golden_ratio_conjugate;
    h = fmodf(h, 1.0);
    UIColor *tempColor = [UIColor colorWithHue:h saturation:0.5 brightness:0.95 alpha:1];
    return tempColor;
}

+(void) showHUD:(UIView*)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.color = SECONDARY_GRAY_COLOR;
        hud.minShowTime = 0.35f;
        hud.activityIndicatorColor = [UIColor blackColor];
        hud.labelText = @"Loading...";
        hud.labelColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    });
}

+(void) hideHUD:(UIView*)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideAllHUDsForView:view animated:YES];
    });
}

-(void) playMenuMusic {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"] == 1 && [self isAbove8]) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/menu.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.backgroundPlayer.numberOfLoops = -1;
        [self.backgroundPlayer play];
    }
}

-(void) playGameMusic {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"] == 1 && [self isAbove8]) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/background_music.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.backgroundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.backgroundPlayer.numberOfLoops = -1;
        [self.backgroundPlayer play];
    }
}

-(void) selectionSound {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"] == 1 && [self isAbove8]) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/selection.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.additionalSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.additionalSoundPlayer.numberOfLoops = 0;
        [self.additionalSoundPlayer play];
    }
}

-(void) backSound {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"] == 1 && [self isAbove8]) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/back.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.additionalSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.additionalSoundPlayer.numberOfLoops = 0;
        [self.additionalSoundPlayer play];
    }
}

-(void) gameOverSound {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"] == 1 && [self isAbove8]) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/game_over.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.additionalSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.additionalSoundPlayer.numberOfLoops = 0;
        [self.additionalSoundPlayer play];
    }
}

-(void) powerUpSound {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"] == 1 && [self isAbove8]) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/powerup.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.additionalSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.additionalSoundPlayer.numberOfLoops = 0;
        [self.additionalSoundPlayer play];
    }
}

-(void) successSound {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"soundState"] == 1 && [self isAbove8]) {
        NSString *soundFilePath = [NSString stringWithFormat:@"%@/success.wav", [[NSBundle mainBundle] resourcePath]];
        NSURL *soundFileURL = [NSURL fileURLWithPath:soundFilePath];
        self.additionalSoundPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:soundFileURL error:nil];
        self.additionalSoundPlayer.numberOfLoops = 0;
        [self.additionalSoundPlayer play];
    }
}

-(void)cancelSounds {
    [self.backgroundPlayer stop];
    [self.additionalSoundPlayer stop];
}

-(void)startSounds {
    [self playMenuMusic];
}

- (BOOL)isAbove8 {
    NSOperatingSystemVersion ios9_0_0 = (NSOperatingSystemVersion){9, 0, 0};
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:ios9_0_0]) {
        return YES;
    } else {
        return NO;
    }
}

@end
