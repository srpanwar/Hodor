//
//  HDRAppDelegate.m
//  Hodor
//
//  Created by Shailesh Panwar on 6/20/14.
//  Copyright (c) 2014 Troupe Of Vagrants. All rights reserved.
//

#import "HDRAppDelegate.h"

@implementation HDRAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];

    //[HDRCurrentUser setCurrentUserName:@"SHAKTIMAN"];
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)data
{
    NSString *deviceToken = [[data description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [HDRCurrentUser setDeviceToken:deviceToken];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDRNetworkProvider instance] sendRemoteNotificationsDeviceToken:deviceToken];
    });
    
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *userName = [userInfo objectForKey:@"sender"];
    userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (userName && userName.length && ![[HDRFriends instance] isFriend:userName])
    {
        HDRUser *newFriend = [[HDRUser alloc] init];
        newFriend.name = [userName uppercaseString];
        newFriend.isBlocked = NO;
        [[HDRFriends instance] addFriend:newFriend];
    }
    
    //store the ping data
    NSString *pingedText = [userInfo objectForKey:@"text"];
    pingedText = (pingedText ? pingedText : @"hodor!!");
    [[HDRFriends instance] setNotification:[userName uppercaseString] text:pingedText];
    
    //refresh the ui
    UINavigationController *root = (UINavigationController *)self.window.rootViewController;
    if (root && [root.topViewController isKindOfClass:[HDRHomeViewController class]] &&  [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [HDRUtils playSoundIncoming];
        
        HDRHomeViewController *controller = (HDRHomeViewController *)root.topViewController;
        [controller refreshView];
    }
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler
{
    [self application:application didReceiveRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
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
    
//    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
//    if (localNotif)
//    {
//        localNotif.alertBody = @"vivekian";
//        localNotif.soundName = @"Hodor.wav";
//        [UIApplication.sharedApplication presentLocalNotificationNow:localNotif];
//    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDRNetworkProvider instance] sendRemoteNotificationsDeviceToken:[HDRCurrentUser getDeviceToken]];
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[HDRNetworkProvider instance] sendRemoteNotificationsDeviceToken:[HDRCurrentUser getDeviceToken]];
    });
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
