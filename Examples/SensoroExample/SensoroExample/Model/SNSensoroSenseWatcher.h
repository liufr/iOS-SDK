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

- (void) startService;
- (void) stopService;

+ (instancetype) sharedInstance;

@end
