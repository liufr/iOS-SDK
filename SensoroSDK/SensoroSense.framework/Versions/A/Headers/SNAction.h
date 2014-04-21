//
//  SNAction.h
//  SensoroSense
//
//  Created by David Yang on 14-4-10.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNZone;
@class SNSpot;

@interface SNActionEvent : NSObject

@property (nonatomic,strong) NSString* type; // "zone" | "spot",
@property (nonatomic,strong) NSString* name; // "enter" | "leave" | "stay",

@property (nonatomic,strong) SNZone* zone; // 交互发生的区
@property (nonatomic,strong) SNSpot* spot; // 交互发生的点

+ (instancetype) getInstanceFrom: (NSDictionary*) dict;

@end

@interface SNAction : NSObject
// -- 基础，对每个不同的 app 都相同
// String timestamp, // 从客户端的发出时间
// int ttl, // 有效期，若 timestamp+ttl < now 则响应无效
@property (nonatomic,strong) NSArray* type; // 交互结果的类型：提示，积分，发券
// -- 扩展，每个 app 不同
@property (nonatomic,strong) NSDictionary* params; // 开发者自行配置的信息，交互参数，积分URL，发券URL等
// -- 交互发生的情况
@property (nonatomic,strong) SNActionEvent* event;

+ (instancetype) getInstanceFrom: (NSDictionary*) dict;

@end
