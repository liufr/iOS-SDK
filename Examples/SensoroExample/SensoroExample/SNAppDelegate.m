//
//  SNAppDelegate.m
//  SensoroExample
//
//  Created by David Yang on 14-4-21.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import "SNAppDelegate.h"
#import "SNSensoroSenseWatcher.h"
#import "SNWebViewController.h"
#import "SNGoodsImageShowController.h"

@implementation SNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[SNSensoroSenseWatcher sharedInstance] startService];
    
    //判断是否是用户点击Notification进入的。
    UILocalNotification *localNotif =
    [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    if (localNotif) {
        NSLog(@"Call didFinishLaunchingWithOptions with local notification %@",localNotif);
        
        NSUInteger type = [[localNotif.userInfo objectForKey:@"type"] integerValue];
        if (type == 1) {
            NSString * url = [localNotif.userInfo objectForKey:@"url"];
            
            if (url != nil) {
                self.localNotifURL = [NSDictionary dictionaryWithObjectsAndKeys:url,@"url",@"yes",@"hasUrl", nil];
                [self showNotificationInfo:localNotif application:application];
            }
        }else if(type == 2 || type == 3){
            NSString * bid = [localNotif.userInfo objectForKey:@"bid"];
            
            if (bid != nil) {
                [self showNotificationInfo:localNotif application:application];
            }
        }
    }
    
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
    [[SNSensoroSenseWatcher sharedInstance] stopService];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    
    UIApplicationState state = [UIApplication sharedApplication].applicationState;
    if ( state == UIApplicationStateInactive ){
        [self showNotificationInfo:notification application:application];
    }
}

- (void) showNotificationInfo:(UILocalNotification*)notification application:(UIApplication*)application{
    NSUInteger type = [[notification.userInfo objectForKey:@"type"] integerValue];
    if (type == 1) {
        NSString * url = [notification.userInfo objectForKey:@"url"];
        
        if (url == nil) {
            return;
        }
        
        SNWebViewController * controller = [[SNWebViewController alloc]
                                            initWithNibName:@"GoodsWeb"
                                            bundle:nil];
        if (controller != nil) {
            controller.url = url;
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
        }
    }else if (type == 2 || type == 3){
        SNGoodsImageShowController * controller = [[SNGoodsImageShowController alloc]
                                                   initWithNibName:@"GoodsImage"
                                                   bundle:nil];
        if (controller != nil) {
            controller.info = notification.userInfo;
            //[controller presentedViewController];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:controller animated:YES completion:nil];
        }
    }else{
        [[UIApplication sharedApplication].keyWindow.rootViewController.navigationController popToRootViewControllerAnimated:YES];
    }
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [application cancelAllLocalNotifications];
}

@end
