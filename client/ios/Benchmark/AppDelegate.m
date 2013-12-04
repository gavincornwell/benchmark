//
//  AppDelegate.m
//  Benchmark
//
//  Created by Gavin Cornwell on 14/09/2013.
//  Copyright (c) 2013 Alfresco. All rights reserved.
//

#import "AppDelegate.h"
#import "BenchmarkLabService.h"
#import "Constants.h"
#import "MockBenchmarkService.h"
#import "TestsViewController.h"
#import "Utils.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // get the app version string
    NSString *appVersionString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    
    // set the application defaults, if necessary
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:kPreferenceUrl] == nil)
    {
        NSMutableDictionary *appDefaults = [NSMutableDictionary dictionaryWithObject:appVersionString forKey:kPreferenceVersion];
        [appDefaults setValue:@YES forKey:kPreferenceTestData];
        [appDefaults setValue:@"http://localhost:9080/alfresco-benchmark-server" forKey:kPreferenceUrl];
        [defaults registerDefaults:appDefaults];
        [defaults synchronize];
    }
    
    // make sure the version string is always up to date
    [defaults setObject:appVersionString forKey:kPreferenceVersion];
    
    // get the defaults
    NSString *urlString = [defaults objectForKey:kPreferenceUrl];
    BOOL useTestData = [[defaults objectForKey:kPreferenceTestData] boolValue];
    
    // determine which benchmark service implementation to use
    id<BenchmarkService> benchmarkService = nil;
    if (useTestData)
    {
        // create the mock service with test data
        benchmarkService = [[MockBenchmarkService alloc] init];
    }
    else
    {
        // create the "real" service, as long as a URL has been provided
        if (urlString != nil && urlString.length > 0)
        {
            NSURL *url = [NSURL URLWithString:urlString];
            benchmarkService = [[BenchmarkLabService alloc] initWithURL:url];
        }
        else
        {
            [Utils displayErrorMessage:@"Test data is disabled but a URL has not been provided, please configure one in the Settings app."];
        }
    }
    
    // create the initial UI
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    TestsViewController *testsView = [[TestsViewController alloc] initWithBenchmarkService:benchmarkService];
    self.viewController = [[UINavigationController alloc] initWithRootViewController:testsView];
    
    // show the UI
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
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
