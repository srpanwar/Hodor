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
    //we dont need the status bar
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    //register to receive notification
    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)])
    {
        [application registerUserNotificationSettings:[UIUserNotificationSettings
                                                       settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
    }
    else
    {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }

    
    [HDRSession setCurrentUserName:@"SRPANWAR"];
    
    //fetch the predefined message list
    dispatch_async_default(^{
        [[HDRNetworkProvider instance] refreshTriviaList];
    });
    
    //update if needed
    [HDRUpdater update];
    
    return YES;
}

#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
#endif

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)data
{
    NSString *deviceToken = [[data description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    [HDRSession setDeviceToken:deviceToken];
    
    dispatch_async_default(^{
        [[HDRNetworkProvider instance] sendRemoteNotificationsDeviceToken:deviceToken];
    });
    
	NSLog(@"My token is: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSString *userName = [userInfo objectForKey:@"sender"];
    userName = [userName stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (userName && userName.length && ![[HDRFriendsProvider instance] isFriend:userName])
    {
        HDRUser *newFriend = [[HDRUser alloc] init];
        newFriend.name = [userName uppercaseString];
        newFriend.isBlocked = NO;
        [[HDRFriendsProvider instance] addFriend:newFriend];
    }
    
    //refresh the ui
    UINavigationController *root = (UINavigationController *)self.window.rootViewController;
    if (root && [root.topViewController isKindOfClass:[HDRHomeViewController class]] &&  [[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
    {
        [HDRSoundService playSoundIncoming];
        
        HDRHomeViewController *controller = (HDRHomeViewController *)root.topViewController;
        [controller refreshView:NO];
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
    
    dispatch_async_default(^{
        [[HDRNetworkProvider instance] sendRemoteNotificationsDeviceToken:[HDRSession getDeviceToken]];
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    dispatch_async_default(^{
        [[HDRNetworkProvider instance] refreshTriviaList];
        [[HDRNetworkProvider instance] sendRemoteNotificationsDeviceToken:[HDRSession getDeviceToken]];
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
