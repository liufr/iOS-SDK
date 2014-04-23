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
#import <SensoroSense/SNZone.h>
#import <SensoroSense/SNAction.h>
#import <SensoroSense/SensoroSense.h>

@interface SNSensoroSenseWatcher () <SNActionDelegate,SensoroSenseDelegate>

//消息观察者
@property (nonatomic,strong) NSMutableArray * watcheres;

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


- (void) addObserver:(id<SensoroSenseDelegate>) watcher
{
    if (self.watcheres == nil) {
        self.watcheres = [NSMutableArray arrayWithCapacity:10];
    }
    
    for (id<SensoroSenseDelegate> cur in self.watcheres) {
        if (cur == watcher) {
            return;
        }
    }
    
    [self.watcheres addObject:watcher];
}

- (void) removeObserver:(id<SensoroSenseDelegate>) watcher
{
    for (id<SensoroSenseDelegate> cur in self.watcheres) {
        if (cur == watcher) {
            [self.watcheres removeObject:watcher];
            return;
        }
    }
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
        [action.event.type isEqualToString:ACTION_SRC_TYPE_ZONE] &&
        action.params != nil) {
        
        id temp = [action.params objectForKey:MESSAGE_KEY];
        if ( temp != nil &&
            [temp isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = temp;
            if ([dict objectForKey:@"content"] != nil) {
                NSDictionary * retInfo = @{@"result":@[@0,
                                                       @{MESSAGE_KEY:[dict objectForKey:@"content"]}]};
                [self shopEnter:retInfo];
            }
        }
        
        temp = [action.params objectForKey:@"goods"];
        if ( temp != nil &&
            [temp isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = temp;
            if ([dict objectForKey:@"content"] != nil) {
                NSString * content = [dict objectForKey:@"content"];
                NSString * url = [dict objectForKey:@"url"];
                
                if (content != nil && url != nil) {
                    NSDictionary * retInfo = @{@"result": @[ @0 , @{MESSAGE_KEY: @{URL_KEY : url,
                                                                                   CONTENT_KEY : content}
                                                                    }]};
                    self.goodsInfo = retInfo;
                    [self goodsOk:retInfo];
                }
            }
        }
    }
    
    if ([action.event.name isEqualToString:LEAVE_KEY] &&
        [action.event.type isEqualToString:ACTION_SRC_TYPE_ZONE]) {
        
        NSDictionary * retInfo = @{@"result": @[ @0 , @{}]};
        
        if (action.params != nil) {//如果有消息，则显示此消息。
            id temp = [action.params objectForKey:MESSAGE_KEY];
            if ( temp != nil &&
                [temp isKindOfClass:[NSDictionary class]]) {
                NSDictionary * dict = temp;
                if ([dict objectForKey:@"content"] != nil) {
                    retInfo = @{@"result":@[@0,
                                           @{MESSAGE_KEY:[dict objectForKey:@"content"]}]};
                }
            }
        }
        
        [self shopLeave:retInfo];
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
    self.isEntering = YES;
    
    for (id<SensoroSenseDelegate> del in self.watcheres) {
        if ([del respondsToSelector:@selector(shopEnter:)]) {
            [del shopEnter:retInfo];
        }
    }
    
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
    self.isEntering = NO;
    
    for (id<SensoroSenseDelegate> del in self.watcheres) {
        if ([del respondsToSelector:@selector(shopEnter:)]) {
            [del shopLeave:retInfo];
        }
    }
    
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

- (void) goodsOk:(NSDictionary*)retInfo{
    for (id<SensoroSenseDelegate> del in self.watcheres) {
        if ([del respondsToSelector:@selector(goodsOk:)]) {
            [del goodsOk:retInfo];
        }
    }
    
    //返回是一个数据，第一项为此次请求的状态。0-成功 1 - 失败。第二项为NSDictionary，结果。
    NSArray * array = [retInfo objectForKey:@"result"];
    
    NSUInteger state = [[array objectAtIndex:0] integerValue];
    if (state != 0) {
        //此处加错误相应处理
        return ;
    }
    
    //不同的接口，有着不同的结果。
    NSDictionary * dict = [array objectAtIndex:1];
    
    NSDictionary * message = [dict objectForKey:MESSAGE_KEY];
    
    if (message != nil &&
        [message isKindOfClass:[NSDictionary class]]) {
        
        NSString * url = [message objectForKey:URL_KEY];
        NSString * content = [message objectForKey:CONTENT_KEY];
        
        if (url && content) {
            NSDictionary* dict = nil;
            
            if (url != nil) {//如果返回的消息里没有url，则使用Shop里面定义的。
                NSMutableDictionary * dictTemp = [NSMutableDictionary dictionaryWithCapacity:1];
                if ([url isEqualToString:@"undefined"]) {
                    [dictTemp setObject:[NSNumber numberWithInt:2]
                                 forKey:@"type"];
                }else{
                    [dictTemp setObject:[NSNumber numberWithInt:1]
                                 forKey:@"type"];
                    
                    [dictTemp setObject:url
                                 forKey:@"url"];
                }
                [dictTemp setObject:content
                             forKey:CONTENT_KEY];
                dict = dictTemp;
            }
            
            [self sendNotification:content userInfo:dict];
            return;
        }
    }
}

@end
