//
//  SNSpot.h
//  SensoroSense
//
//  Created by David Yang on 14-4-10.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNActionState;

@interface SNSpotInfo : NSObject

@property (nonatomic,strong) NSString* location; // 安装位置（如：门口，款台）
@property (nonatomic,strong) NSString* owner; // 安装者
@property (nonatomic,strong) NSDate* date; // 安装时间
@property (nonatomic,strong) NSString* name; // 名字
@property (nonatomic,strong) NSString* type; // beacon 的 type，如，店铺，广告牌，
@property (nonatomic,strong) NSString* address; // 地址：以 path 结构组织
@property (nonatomic,strong) NSString* picture; // 图片

@property float lat; // 经度
@property float lon; // 纬度

+ (instancetype) getInstanceFrom: (NSDictionary*) dict;

@end

@interface SNSpot : NSObject

// -- 基础，对每个不同的 app 都相同
@property (nonatomic,strong) NSString* indentifyKey; // 点的beacon id 由UUID+major+minor
@property (nonatomic,strong) NSString* bid; // 点的beacon id
@property (nonatomic,strong) NSString* spotID; // 点的内部 id,有APP定义。
@property (nonatomic,strong) SNSpotInfo* spotInfo; // 点的内部 id
// -- 扩展，每个 app 可不同
@property (nonatomic,strong) NSDictionary* params; // 开发者自行配置的信息
@property (nonatomic,strong) NSString* type;//params中type信息。

@property (nonatomic,strong) NSArray* zids;//区域ID,属于多个区域。

@property (nonatomic,strong) NSDate * entryTime;//进入的时间
@property (nonatomic,strong) NSDate * firedTime;//上次激活Stay时的时间。

@property (nonatomic,strong) SNActionState * action;

+ (instancetype) getInstanceFrom: (NSDictionary*) dict;

@property (readonly) BOOL isDirty;

@end
