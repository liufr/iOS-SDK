//
//  SNViewController.m
//  SensoroExample
//
//  Created by David Yang on 14-4-21.
//  Copyright (c) 2014年 Sensoro. All rights reserved.
//

#import "SNViewController.h"
#import "SNSensoroSenseWatcher.h"

@interface SNViewController () <SensoroSenseDelegate>

@property (weak, nonatomic) IBOutlet UILabel *enterState;
@property (weak, nonatomic) IBOutlet UILabel *goodsState;

@end

@implementation SNViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    [[SNSensoroSenseWatcher sharedInstance] addObserver:self];
    if ([SNSensoroSenseWatcher sharedInstance].isEntering) {
        self.enterState.text = @"已进场";
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

#pragma mark SensoroSenseDelegate

- (void) shopEnter:(NSDictionary*)retInfo{
    if ([SNSensoroSenseWatcher sharedInstance].isEntering) {
        self.enterState.text = @"已进场";
    }
}

- (void) shopLeave:(NSDictionary*)retInfo{
    if ([SNSensoroSenseWatcher sharedInstance].isEntering == NO) {
        self.enterState.text = @"已离场";
    }
}

- (void) goodsOk:(NSDictionary*)retInfo{
    if ([SNSensoroSenseWatcher sharedInstance].goodsInfo != nil) {
        self.goodsState.text = @"已触发";
    }
}

- (void) creditOk:(NSDictionary*)retInfo{
}

- (void) fixedCornerEnter:(NSDictionary*)retInfo{
}

- (void) fixedCornerLeave:(NSDictionary*)retInfo{
}

- (void) payAreaEnter:(NSDictionary*)retInfo{
}

- (void) payAreaLeave:(NSDictionary*)retInfo{
}

@end
