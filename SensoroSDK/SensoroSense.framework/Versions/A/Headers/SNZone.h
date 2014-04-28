//
//  SNZone.h
//  SensoroSense
//
//  Created by David Yang on 14-4-10.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SNActionState;

@interface SNZone : NSObject

@property (nonatomic,strong) NSString* zid;
@property (nonatomic,strong) SNActionState* action;
@property (nonatomic,strong) NSDictionary* params;

@property (readonly) BOOL isDirty;

+ (instancetype) getInstanceFrom: (NSDictionary*) dict;

@end
