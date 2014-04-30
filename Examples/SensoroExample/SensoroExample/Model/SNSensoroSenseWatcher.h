//
//  SNSenseWatcher.h
//  SensoroExample
//
//  Created by David Yang on 14-4-21.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  通过实现SensoroSenseDelegate的接口方法,以检测相应的事件
 */
@protocol SensoroSenseDelegate <NSObject>

@optional

/**
 *  回调：进场消息
 *
 *  @param retInfo 回调参数，存储通过Action回调的各项参数
 */
- (void) shopEnter:(NSDictionary*)retInfo;
/**
 *  回调：离场消息
 *
 *  @param retInfo 回调参数，存储通过Action回调的各项参数
 */
- (void) shopLeave:(NSDictionary*)retInfo;

/**
 *  回调：一体化购物消息
 *
 *  @param retInfo 回调参数，存储通过Action回调的各项参数
 */
- (void) goodsOk:(NSDictionary*)retInfo;
/**
 *  回调：积分消息
 *
 *  @param retInfo 回调参数，存储通过Action回调的各项参数
 */
- (void) creditOk:(NSDictionary*)retInfo;

/**
 *  回调：淘金角进入
 *
 *  @param retInfo 回调参数，存储通过Action回调的各项参数
 */
- (void) fixedCornerEnter:(NSDictionary*)retInfo;
/**
 *  回调：淘金角离开
 *
 *  @param retInfo 回调参数，存储通过Action回调的各项参数
 */
- (void) fixedCornerLeave:(NSDictionary*)retInfo;

/**
 *  回调：进入支付区域
 *
 *  @param retInfo 回调参数，存储通过Action回调的各项参数
 */
- (void) payAreaEnter:(NSDictionary*)retInfo;
/**
 *  回调：离开支付区域
 *
 *  @param retInfo 回调参数，存储通过Action回调的各项参数
 */
- (void) payAreaLeave:(NSDictionary*)retInfo;

@end

@interface SNSensoroSenseWatcher : NSObject

/**
 *  是否已经进场
 */
@property BOOL isEntering;

/**
 *  是否在认证区域
 */
@property BOOL isVerifyArea;

/**
 *  获取积分的次数
 */
@property NSUInteger creditTimes;

/**
 *  认证区域id
 */
@property NSString * vid;

/**
 *  淘金角id
 */
@property NSString * pid;

/**
 *  是否在淘金角内
 */
@property (nonatomic,assign) BOOL isFixedCorner;

/**
 *  一体化购物商品信息
 */
@property (nonatomic,strong) NSDictionary* goodsInfo;

/**
 *  开启蓝牙监测服务
 */
- (void) startService;

/**
 *  关闭蓝牙监测服务
 */
- (void) stopService;

/**
 *  添加观测者
 *
 *  @param watcher 实现了SensoroSenseDelegate的委托观测者
 */
- (void) addObserver:(id<SensoroSenseDelegate>) watcher;

/**
 *  删除观测者
 *
 *  @param watcher 实现了SensoroSenseDelegate的委托观测者
 */
- (void) removeObserver:(id<SensoroSenseDelegate>) watcher;

/**
 *  单例方法
 *
 *  @return 唯一的实例对象
 */
+ (instancetype) sharedInstance;

@end
