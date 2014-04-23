//
//  SNSenseWatcher.h
//  SensoroExample
//
//  Created by David Yang on 14-4-21.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SensoroSenseDelegate <NSObject>

@optional
- (void) shopEnter:(NSDictionary*)retInfo;
- (void) shopLeave:(NSDictionary*)retInfo;

- (void) goodsOk:(NSDictionary*)retInfo;
- (void) creditOk:(NSDictionary*)retInfo;

- (void) fixedCornerEnter:(NSDictionary*)retInfo;
- (void) fixedCornerLeave:(NSDictionary*)retInfo;

- (void) payAreaEnter:(NSDictionary*)retInfo;
- (void) payAreaLeave:(NSDictionary*)retInfo;

@end

@interface SNSensoroSenseWatcher : NSObject

@property BOOL isEntering;
@property BOOL isFixedCorner;
@property BOOL isVerifyArea;

@property (nonatomic,strong) NSDictionary* goodsInfo;

- (void) startService;
- (void) stopService;

//添加观测者。
- (void) addObserver:(id<SensoroSenseDelegate>) watcher;
//删除观测者。
- (void) removeObserver:(id<SensoroSenseDelegate>) watcher;

+ (instancetype) sharedInstance;

@end
