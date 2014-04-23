//
//  SNDiscountViewController.m
//  SensoroDemo
//
//  Created by Jarvis on 14-1-8.
//  Copyright (c) 2014年 David Yang. All rights reserved.
//

#import "SNGoodsImageShowController.h"

@interface SNGoodsImageShowController ()

@end

@implementation SNGoodsImageShowController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.msgLabel.textColor = [UIColor colorWithRed:0.557 green:0.278 blue:0.129 alpha:1.0];
    [self updateState];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    [SNInviteSummary sharedInstance].watcher = self;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
//    [SNInviteSummary sharedInstance].watcher = nil;
}

- (void)setCouponImage:(UIImage *)placeholder imageURL:(NSURL *)url
{
    [self.couponImg setImageWithURL:url placeholderImage:placeholder];
}

- (void)cleanURL
{
    [self.couponImg setImage:nil];
}

- (void)setMsg:(NSString *)msg
{
    _msgLabel.text = msg;
}

- (IBAction)backToPrev:(id)sender {
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark SNInviteSummaryStateDelegate

- (void) stateChanged{
    //[self updateState];
}

- (void) enterGoodsArea{
    [self updateState];
}

- (void) leaveGoodsArea{
    [self updateState];
}

- (void) updateState{
    if (self.info != nil) {
        NSString * url = [self.info objectForKey:@"image"];
        NSString * content = [self.info objectForKey:@"content"];
        
        [self.couponImg setImageWithURL:[NSURL URLWithString:url]
                       placeholderImage:[UIImage imageNamed:@"coupon"]];
        [self setMsg:content];
    }else{
        [self cleanURL];
        [self setMsg:@"未在商品区域内"];
    }
}

@end
