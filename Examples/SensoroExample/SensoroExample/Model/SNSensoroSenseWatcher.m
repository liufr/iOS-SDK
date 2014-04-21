//
//  SNSenseWatcher.m
//  SensoroExample
//
//  Created by David Yang on 14-4-21.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import "SNSensoroSenseWatcher.h"
#import "KeyDefine.h"
#import <SensoroSense/SNSpot.h>
#import <SensoroSense/SNAction.h>
#import <SensoroSense/SensoroSense.h>

@interface SNSensoroSenseWatcher () <SNActionDelegate>

@end

@implementation SNSensoroSenseWatcher

+ (instancetype) sharedInstance{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}

- (void) startService{
    [[SensoroSense sharedInstance] startService:@"1" appKey:@"SensoroExample" options:nil];
    [[SensoroSense sharedInstance] addObserver:self];
}

- (void) stopService{
    [[SensoroSense sharedInstance] stopService];
    [[SensoroSense sharedInstance] removeObserver:self];
}

#pragma mark SNActionDelegate

- (void) onAction:(SNAction *)action{
//    NSString* catchKey = @"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0-0004-0007";
//    if ([action.event.spot.indentifyKey isEqualToString:catchKey] &&
//        [action.event.name isEqualToString:@"enter"]) {
//        NSLog(@"on action:%@",action);
//    }
//    
    //进场消息
    if ([action.event.name isEqualToString:ENTER_KEY] &&
        action.params != nil) {
        if ([action.params objectForKey:@"message"] != nil &&
            [[action.params objectForKey:@"message"] isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = [action.params objectForKey:@"message"];
            if ([dict objectForKey:@"content"] != nil) {
                NSDictionary * retInfo = @{@"result":@[@0,
                                                       @{@"message":[dict objectForKey:@"content"]}]};
                [self shopEnter:retInfo];
            }
        }
    }
}

#pragma mark Notification method

- (void) sendNotification:(NSString *) message userInfo:(NSDictionary*) dict{
    
    //发送消息通知给系统。
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = message;
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground) {
        notification.applicationIconBadgeNumber = 1;
    }
    
    if (dict != nil) {
        notification.userInfo = dict;
    }
    
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void) shopEnter:(NSDictionary*)retInfo{
    NSLog(@"enter shop userInfo: %@",retInfo);
    //返回是一个数据，第一项为此次请求的状态。0-成功 1 - 失败。第二项为NSDictionary，结果。
    NSArray * array = [retInfo objectForKey:@"result"];
    
    NSUInteger state = [[array objectAtIndex:0] integerValue];
    if (state != 0) {
        //此处加错误相应处理
        return ;
    }
    
    //不同的接口，有着不同的结果。
    NSDictionary * dict = [array objectAtIndex:1];
    
    NSString * message = [dict objectForKey:@"message"];
    if (message != nil) {
        [self sendNotification:message userInfo:nil];
    }else{
        NSLog(@"entry message is error cannot find value of \"message\" in result");
    }
}

- (void) shopLeave:(NSDictionary*)retInfo{
    //返回是一个数据，第一项为此次请求的状态。0-成功 1 - 失败。第二项为NSDictionary，结果。
    NSArray * array = [retInfo objectForKey:@"result"];
    
    NSUInteger state = [[array objectAtIndex:0] integerValue];
    if (state != 0) {
        //此处加错误相应处理
        return ;
    }
    
    //不同的接口，有着不同的结果。
    NSDictionary * dict = [array objectAtIndex:1];
    
    NSString * message = [dict objectForKey:@"message"];
    if (message != nil) {
        [self sendNotification:message userInfo:nil];
    }else{
        NSLog(@"leave message is error cannot find value of \"message\" in result");
    }
}

@end
