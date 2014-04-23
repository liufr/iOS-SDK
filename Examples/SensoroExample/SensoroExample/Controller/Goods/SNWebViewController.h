//
//  SNWebViewController.h
//  SNNotificationDemo
//
//  Created by David Yang on 13-12-5.
//  Copyright (c) 2013年 David Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SNWebViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (nonatomic,strong) NSString* url;

- (IBAction)closeView:(id)sender;

@end
