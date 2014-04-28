//
//  SNSensor.h
//  SensoroAnswer
//
//  Created by David Yang on 14-1-9.
//  Copyright (c) 2014年 David Yang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

#define DISTANCE_BUF_SIZE   5
#define INVALID_DISTANCE    100000

@class SNBeacon;

@interface SNSensor : NSObject

@property (readonly) NSString* key;
@property (nonatomic,strong) NSString* uuid;
@property (nonatomic,strong) NSNumber* major;
@property (nonatomic,strong) NSNumber* minor;

@property CLProximity proximity;
@property NSInteger rssi;
@property (readonly)CLLocationAccuracy distance; //现在的距离
@property (readonly)CLLocationAccuracy minDistance; //曾经到过的最小距离。
@property (readonly)CLLocationAccuracy lastDistance; //现在的距离

@property (readonly)CLLocationAccuracy bleDistance; //现在的距离
@property (readonly)CLLocationAccuracy minBleDistance; //曾经到过的最小距离。
@property (readonly)CLLocationAccuracy lastBleDistance; //现在的距离

@property (nonatomic,strong) NSDate * entryTime;//进入的时间
@property (nonatomic,strong) NSDate * lastUpdateTime;//最后一次更新的时间。
@property NSUInteger stayTime; //停留时间
@property BOOL isOutOfRegion;//是否在Beacon的区域内，即没有接到信号。

- (void) pushDistance:(CLLocationAccuracy) dist;
- (void) clearDistance;
- (void) pushBleDistance:(CLLocationAccuracy) dist;
- (void) clearBleDistance;

+ (instancetype) getInstanceFrom:(CLBeacon *) beacon;
+ (instancetype) getInstanceFromBleBeacon:(SNBeacon *) beacon;

@end
