//
//  SNAnswerConfig.h
//  SensoroAnswer
//
//  Created by David Yang on 14-2-5.
//  Copyright (c) 2014年 David Yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SNAnswerConfig : NSObject

@property (nonatomic,strong) NSString * brandID;

@property (readonly) NSUInteger spotFireTimeInterval;//场内超时时长
@property (readonly) NSUInteger zoneFireTimeInterval;//场外超时时长

@property (readonly) NSUInteger cacheDirtyTimeInterval;//Cache数据变为需要更新状态所需的时间间隔。
@property (readonly) NSUInteger cacheUpdateDistance;//Cache数据取得的距离间距。

- (void) configFromServer:(NSDictionary*)config;
- (void) loadConfigFromServer;


+ (instancetype)sharedInstance;

@end
