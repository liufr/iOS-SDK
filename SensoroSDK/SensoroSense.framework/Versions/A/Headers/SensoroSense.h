//
//  SensoroSense.h
//  SensoroSense
//
//  Created by David Yang on 14-4-9.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNAction;

@protocol SNActionDelegate <NSObject>

@optional

- (void) onAction:(SNAction*) action;

@end

@interface SensoroSense : NSObject

@property (readonly) BOOL isServing;

//添加观测者。
- (void) addObserver:(id<SNActionDelegate>) watcher;
//删除观测者。
- (void) removeObserver:(id<SNActionDelegate>) watcher;

- (void) startService:(NSString*)appID appKey:(NSString *)appKey options:(NSDictionary*)options;
- (void) stopService;

+ (instancetype)sharedInstance;

@end
