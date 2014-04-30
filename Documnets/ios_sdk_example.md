### iOS SDK Example文档  

#### 项目概述   

该项目使用SDK的Action层接口，演示了SDK的几个基本商业场景的实现，主要包括： 
 
- 进店消息，一体化购物（进入区域）  
- 离店消息（离开区域）   
- 积分获取（在区域内停留）  
- 淘金角（点的进入、离开及停留）   
- 支付认证区域（点的进入、离开）

该项目在__SNSensoroSenseWatcher__实现了SDK Action层的相关接口，并针对实际商业场景封装了响应的接口

####  SNSensoroSenseWatcher.h
##### 生命周期接口

- 开始

```
	[[SNSensoroSenseWatcher sharedInstance] startService];
	[[SNSensoroSenseWatcher sharedInstance] addObserver:self];
```

- 结束

```
	[[SNSensoroSenseWatcher sharedInstance] stopService];
	[[SNSensoroSenseWatcher sharedInstance] removeObserver:self];
```

添加的观测者需要通过实现SensoroSenseDelegate的接口方法,以检测相应的事件

##### 接口SensoroSenseDelegate
接口由SNSensoroSenseWatcher定义的观测者来实现   

```
// 回调:进入商店
- (void) shopEnter:(NSDictionary*)retInfo;
// 回调:离开商店
- (void) shopLeave:(NSDictionary*)retInfo;

// 回调:一体化购物消息 
- (void) goodsOk:(NSDictionary*)retInfo;
// 回调:积分消息
- (void) creditOk:(NSDictionary*)retInfo;

// 回调:进入淘金角
- (void) fixedCornerEnter:(NSDictionary*)retInfo;
// 回调:离开淘金角
- (void) fixedCornerLeave:(NSDictionary*)retInfo;

// 回调:进入支付区域
- (void) payAreaEnter:(NSDictionary*)retInfo;
// 回调:离开支付区域
- (void) payAreaLeave:(NSDictionary*)retInfo;
```

retInfo是一个NSDictionary对象，可以存储通过Action回调的各项参数，其中第一项为此次请求的状态。0-成功 1 - 失败。第二项为NSDictionary，内容为返回的参数内容,retInfo结构参考示例:

```  
 @{@"result" :	@[ @0,
 			  	   @{@"message":@"enter message"}
 			  	 ]
  };
```

#### 商业场景实现

###### 头文件

该项目需要导入Action层相关的头文件

```
#import <SensoroSense/SensoroSense.h>
#import <SensoroSense/SNAction.h>
#import <SensoroSense/SNZone.h>
#import <SensoroSense/SNSpot.h>
```

本示例代码中的商业场景是通过SensoroSenseDelegate的**- (void) onAction:(SNAction *)action**回调方法实现的，其中action参数的具体定义可参考SDK文档

##### 进店、离店消息   

进店、离店消息是通过监测进出区域进行响应的

1. 通过判断action中event的name属性和type属性来判断是否为进入区域事件
2. 判断action参数的param变量，如果param中有以message为key的变量，则判断为设备进店，并返回响应的message信息  

* 进店消息实现代码片段

```
//进场消息
if ([action.event.name isEqualToString:@"enter"] &&
    [action.event.type isEqualToString:@"zone"]) {
    
    NSDictionary * retInfo = @{@"result": @[ @0 , @{}]};
    
    //如果有消息，则显示此消息。
    if (action.params != nil) {
        id temp = [action.params objectForKey:@"message"];
        if ( temp != nil &&
            [temp isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = temp;
            if ([dict objectForKey:@"content"] != nil) {
                retInfo = @{@"result":@[@0,
                                        @{@"message":[dict objectForKey:@"content"]}]};
            }
        }
    }
	[self shopEnter:retInfo];
}
```

* 离店消息实现代码片段

```
//离场消息
if ([action.event.name isEqualToString:@"leave"] &&
    [action.event.type isEqualToString:@"zone"]) {
    
    NSDictionary * retInfo = @{@"result": @[ @0 , @{}]};
    
    //如果有消息，则显示此消息。
    if (action.params != nil) {
        id temp = [action.params objectForKey:@"message"];
        if ( temp != nil &&
            [temp isKindOfClass:[NSDictionary class]]) {
            NSDictionary * dict = temp;
            if ([dict objectForKey:@"content"] != nil) {
                retInfo = @{@"result":@[@0,
                                        @{@"message":[dict objectForKey:@"content"]}]};
            }
        }
    }
    [self shopLeave:retInfo];
}
```

##### 一体化购物消息

一体化购物场景与进场消息实现方式类似，都是在进入区域时触发，与进场消息不同点在于一体化购物携带了商品的信息，如商品图片、链接等，一体化购物的代码实现片段如下

```
//一体化购物
retInfo =  @{@"result": @[ @0 , @{}]};
if (action.params != nil) {
    id temp = [action.params objectForKey:@"goods"];
    if ( temp != nil && [temp isKindOfClass:[NSDictionary class]]) {
        NSDictionary * dict = temp;
        if ([dict objectForKey:@"content"] != nil) {
            NSString * content = [dict objectForKey:@"content"];
            NSString * url = [dict objectForKey:@"url"];
            
            if (content != nil && url != nil) {
                NSDictionary * retInfo = @{@"result": @[ @0 , @{MESSAGE_KEY: @{URL_KEY : url,
                                                                               CONTENT_KEY : content}
                                                                }]};
                self.goodsInfo = retInfo;
                [self goodsOk:retInfo];
            }
        }
    }
}
```

##### 淘金角  

淘金角的场景是在用户进入某个点的区域后触发的

* 由于用户可能会位于多个标记为淘金角的Beacon范围内，因此需要判断是否在淘金角范围内，只有当用户所在的区域中没有淘金角Beacon的时候才显示为离场，否则判断用户在淘金角范围内


* 在头文件中声明相关成员变量
	

```   
//判断是否在淘金角范围内
@property (nonatomic,assign) BOOL isFixedCorner;

//存放标记为淘金角的Action信息，如果cornerDict为空，则判断为在淘金角区域外，不为空，则判断为在淘金角区域内
@property (nonatomic,strong) NSMutableDictionary * cornerDict;

```   

* 重写isFixedCorner的set方法


```
- (BOOL)isFixedCorner
{
    if ([[self.cornerDict allKeys] count] > 0)
    {
        return YES;
    }
    return NO;
}

- (void)onInCorner:(SNAction *)action
{
    if (_cornerDict == nil) {
        _cornerDict = [[NSMutableDictionary alloc] initWithCapacity:100];
    }
    
    NSString * indentifyKey = action.event.spot.indentifyKey;
    [_cornerDict setObject:action forKey:indentifyKey];
}

- (void)onOutCorner:(SNAction *)action
{
    NSString * indentifyKey = action.event.spot.indentifyKey;
    if ([_cornerDict objectForKey:indentifyKey] != nil) {
        [_cornerDict removeObjectForKey:indentifyKey];
    }
}
```

* 在__- (void) onAction:(SNAction *)action__回调中实现标记为淘金角的点区域在激活事件时的判断代码，以下为相关的代码片段


```
//淘金角
if ([action.event.type isEqualToString:@"spot"] &&
    action.event.spot != nil) {
    
    NSDictionary * retInfo = @{@"result": @[@0 , @{}]};
    
    if ([action.event.spot.type isEqualToString:@"fixedcorner"]) {
        BOOL oldInCorner = self.isFixedCorner;
        
        if ([action.event.name isEqualToString:@"leave"]) {
            NSLog(@"leave fixed corner!");
            [self onOutCorner:action];
            
            if (self.isFixedCorner == NO) {
                self.pid = nil;
            }
        }
        
        //获取pid
        if ([action.event.spot.params objectForKey:PID_KEY] != nil) {
        	//可以使用pid确定具体的淘金角所代表的位置点
            self.pid = [NSString stringWithFormat:@"%@",[action.event.spot.params objectForKey:PID_KEY]];
        }else{
            return;
        }
        
        
        if ([action.event.name isEqualToString:ENTER_KEY]) {
            [self onInCorner:action];
            
        }
        
        if ([action.event.name isEqualToString:STAY_KEY]) {
            [self onInCorner:action];
        }
        
        //根据先前位置判断进出场
        if (self.isFixedCorner == YES &&
            oldInCorner == NO) {
            for (id<SensoroSenseDelegate> del in self.watcheres) {
                if ([del respondsToSelector:@selector(fixedCornerEnter:)]) {
                    [del fixedCornerEnter:retInfo];
                }
            }
        }else if (self.isFixedCorner == NO &&
                  oldInCorner == YES){
            for (id<SensoroSenseDelegate> del in self.watcheres) {
                if ([del respondsToSelector:@selector(fixedCornerLeave:)]) {
                    [del fixedCornerLeave:retInfo];
                }
            }
        }
    }
}
```
