//
//  SensoroAnswer.h
//  SensoroAnswer
//
//  Created by David Yang on 13-11-21.
//  Copyright (c) 2013年 David Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#pragma mark Protocol

//绑定到对象上的信息。
@protocol SNSensoroHWServiceDelegate <NSObject>

//@optional

//进入某些传感器的区域。
- (void) onNew: (NSArray*) sensors;
//离开某些传感器的区域。
- (void) onGone: (NSArray*) sensors;

@end

@interface SensoroSenseHW : NSObject

@property (readonly) CLLocation *curLoc;

@property (readonly) BOOL isServing;

//获取现在的范围内的传感器。
- (NSArray*) getBeacons;
- (NSDictionary*) getBeaconsWithBid;

//启动服务
- (void) startService;
//停止服务。
- (void) stopService;

//添加观测者。
- (void) addObserver:(id<SNSensoroHWServiceDelegate>) watcher;
//删除观测者。
- (void) removeObserver:(id<SNSensoroHWServiceDelegate>) watcher;

+ (instancetype )sharedInstance;

@end
