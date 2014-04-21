//
//  SNGlobalTrigger.h
//  WanDaLive
//
//  Created by David Yang on 13-11-28.
//  Copyright (c) 2013年 David Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNSpot;
@class SNZone;

@protocol SNBeaconConfigDelegate <NSObject>

- (NSDictionary *) getBeaconConfig:(NSString * )beaonID;

@end

@protocol SNZoneTriggerDelegate <NSObject>

// 回调：进入点
- (void) onEnterSpot:(SNSpot*) spot zone:(SNZone*) zone;
// 回调：离开点
- (void) onLeaveSpot:(SNSpot*) spot zone:(SNZone*) zone;
// 回调：在点停留，若一直停留，则多次回调，间隔为最小停留时间单位
- (void) onStaySpot:(SNSpot*) spot zone:(SNZone*) zone stayTime: (NSTimeInterval) seconds;
// 回调：进入区
- (void) onEnterZone:(SNZone*) zone spot: (SNSpot *) spot;
// 回调：离开区
- (void) onLeaveZone:(SNZone*) zone spot: (SNSpot *) spot;
// 回调：在区停留，若一直停留，则多次回调，间隔为最小停留时间单位
- (void) onStayZone: (SNZone*) zone spot: (SNSpot *) spot stayTime: (NSTimeInterval) seconds;

@end


@interface SNZoneManager : NSObject

@property (readonly) BOOL isServing;

@property (nonatomic,retain) id<SNBeaconConfigDelegate> beconConfig;

//添加观测者。
- (void) addObserver:(id<SNZoneTriggerDelegate>) watcher;
//删除观测者。
- (void) removeObserver:(id<SNZoneTriggerDelegate>) watcher;

- (void) startService;
- (void) stopService;

+ (instancetype)sharedInstance;

@end
