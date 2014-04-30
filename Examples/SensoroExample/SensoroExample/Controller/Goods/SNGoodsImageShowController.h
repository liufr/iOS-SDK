//
//  SNDiscountViewController.h
//  SensoroDemo
//
//  Created by Jarvis on 14-1-8.
//  Copyright (c) 2014年 David Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface SNGoodsImageShowController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *couponImg;
@property (weak, nonatomic) IBOutlet UILabel *msgLabel;

@property (weak, nonatomic) NSDictionary * info;

- (IBAction)backToPrev:(id)sender;

/**
 *  设置优惠券的图片
 *
 *  @param placeholder 占位图片
 *  @param url         读取图片的url，不用时要使用清空方法清空
 */
- (void)setCouponImage:(UIImage *)placeholder imageURL:(NSURL *)url;
- (void)setMsg:(NSString *)msg;
- (void)cleanURL;

@end
