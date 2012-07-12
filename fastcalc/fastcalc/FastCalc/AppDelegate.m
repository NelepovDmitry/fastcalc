//
//  AppDelegate.m
//  FastCalc
//
//  Created by Gevorg Petrosyan on 01.06.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "MainViewController.h"
#import "ChooseViewController.h"
#import "IIViewDeckController.h"
#import "iRate.h"
#import "ApplicationSingleton.h"
#import "FMStore.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize leftController = _leftController;

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    ApplicationSingleton *appSingleton = [ApplicationSingleton createSingleton];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    [iRate sharedInstance].appStoreID = 484567469;
    [FMStore sharedStore];
    
    self.leftController = [[ChooseViewController alloc] initWithNibName:@"ChooseViewController" bundle:nil];
    
    MainViewController *mainController = [[[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil] autorelease];
    appSingleton.mainViewController = mainController;
    self.viewController = [[UINavigationController alloc] initWithRootViewController:mainController];
    
    IIViewDeckController* deckController =  [[IIViewDeckController alloc] initWithCenterViewController:self.viewController 
                                                                                    leftViewController:self.leftController
                                                                                   rightViewController:nil];
    deckController.rightLedge = 100;
    self.window.rootViewController = deckController;
    [self.window makeKeyAndVisible];
    NSLog(@"appSingleton.idOfMenu %@", appSingleton.idOfMenu);
    if(appSingleton.firstStart || appSingleton.idOfMenu.integerValue == 0) {
        [deckController toggleLeftView];
    }
    [mainController release];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
