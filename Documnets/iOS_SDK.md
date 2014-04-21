### iOS SDK文档

#### 工程配置

1. 添加SensoroSensse.framework。
2. 添加libstdc++.6.0.9.dylib和libc++.dylib链接库
3. 添加CoreBluetooth.framework，CoreLocation.framework，SystemConfiguration.framework等framework
4. 在Build Settings中Other Linker Flags设定 “-ObjC”编译选项。
5. 在Info.plist中添加Required background modes并添加“location”，即"App registers for location updates"选项。

#### 头文件

项目为三层结构，一下是各层的会使用到的头文件。

- 基础层。

```
#import <SensoroSense/SNSensor.h>
#import <SensoroSense/SensoroSenseHW.h>
```

- 逻辑层

```
#import <SensoroSense/SNZoneManager.h>
#import <SensoroSense/SNAnswerConfig.h>
#import <SensoroSense/SNSpot.h>
#import <SensoroSense/SNZone.h>
```

- 交互层

```
#import <SensoroSense/SensoroSense.h>
#import <SensoroSense/SNAction.h>
```

#### APP和SDK接口

##### 交互层

在这一层 APP 只关心交互导致的结果，并不关心交互如何发生。比如，交互的结果是获得了积分，而产生积分的交互有可能是进入、离开或停留，任何一种交互最终都会导致“获得积分”的结果，规则和参数可在服务端配置。这个层次的 APP 只关心现在积分被触发了，需要如何处理，并不关心是什么触发了这个结果。

###### 生命周期接口
- 开始：

```
    [[SensoroSense sharedInstance]startService:@"1" appKey:@"1" options:nil];
    [[SensoroSense sharedInstance]addObserver:self];//监测类需要实现SNActionDelegate接口，以检测相应的Action
```
- 结束：

```
    [[SensoroSense sharedInstance] stopService];
    [[SensoroSense sharedInstance] removeObserver:self];
```

##### 接口 SNActionDelegate
接口由观测者来实现。

```
- (void) onAction:(SNAction*) action;
```

SNAction有如下各个成员变量：

- type: //APP，交互的结果。
- params: // 开发者自行配置的信息，交互参数，积分URL，发券URL等
- event: //SNActionEvent类型

SNActionEvent成员变量

- name //事件类型。三种值："enter"，"leave"，"stay"。
- type //事件发起者类型 spot | zone
- zone //所发生的区域。
- spot //所发生的点。

##### 逻辑层 

在这一层，当事件发生时，SDK 会把交互发生的场景信息（类似 POI）通知给 APP，APP 可直接处理。 SDK 无论工作在何种状态（在线离线）都会把此事件通知服务端。在线处理的情况下，SDK 会通知服务端，并等待响应；离线处理的情况下，SDK 会在本地运行配置，然后将交互结果，以 Action 层回调通知 APP 做处理。

###### 生命周期接口

- 开始：

```
    [[SNAnswerConfig sharedInstance] setBrandID:@"1"];//设定APP ID
    [[SNZoneManager sharedInstance] startService];//启动服务
    [[SNZoneManager sharedInstance] addObserver:self];//注册观察者。
```

- 结束：

```
    [[SNZoneManager sharedInstance] stopService];//停止服务
    [[SNZoneManager sharedInstance] removeObserver:self];//删除观察者。
```

##### 接口 SNZoneTriggerDelegate
接口由观测者来实现。

```
// 回调：进入点
- (void) onEnterSpot:(SNSpot*) spot zone:(SNZone*) zone;
// 回调：离开点
- (void) onLeaveSpot:(SNSpot*) spot zone:(SNZone*) zone;
// 回调：在点停留，若一直停留，则多次回调，间隔为最小停留时间单位
- (void) onStaySpot:(SNSpot*) spot zone:(SNZone*) zone stayTime: (NSTimeInterval) seconds;
// 回调：进入区
- (void) onEnterZone:(SNZone*) zone spot: (SNSpot *) spot;
// 回调：离开区
- (void) onLeaveZone:(SNZone*) zone spot: (SNSpot *) spot;
// 回调：在区停留，若一直停留，则多次回调，间隔为最小停留时间单位
- (void) onStayZone: (SNZone*) zone spot: (SNSpot *) spot stayTime: (NSTimeInterval) seconds;

```

> 注：onEnterZone(zone1, spot1) 和 onEnterSpot(spot1, zone1) 的区别在于，前者意味着“从 spot1 进入 zone1”，后者意味着“进入 spot1，而且 spot1 从属于 zone1”（zone 也可能为 null，以表达 spot 并不从属于任何的 zone）。若 zone1 包含 3 个 spot ，依次经过各个点，则后者可能会被调用 3 次，而前者只会被调用 1 次。

相应的类，参考SNSpot，SNZone等定义。

- Spot

```
NSString* indentifyKey; // 点的beacon id 由UUID+major+minor
NSString* bid; // 点的beacon id
NSString* spotID; // 点的内部 id,有APP定义。
SNSpotInfo* spotInfo; // 点的内部 id
// -- 扩展，每个 app 可不同
NSDictionary* params; // 开发者自行配置的信息
NSString* type;//params中type信息。
NSArray* zids;//区域ID,属于多个区域。
NSDate * entryTime;//进入的时间
NSDate * firedTime;//上次激活Stay时的时间。
SNActionState * action;
```

- SNSpotInfo

```
NSString* location; // 安装位置（如：门口，款台）
NSString* owner; // 安装者
NSDate* date; // 安装时间
NSString* name; // 名字
NSString* type; // beacon 的 type，如，店铺，广告牌，
NSString* address; // 地址：以 path 结构组织
NSString* picture; // 图片
float lat; // 经度
float lon; // 纬度
```

- Zone

```
NSString* zid; //Zone ID
SNActionState* action; //Zone上的Action
NSDictionary* params; //Zone上参数。
```


##### 硬件层

在这一层，基本就是iBeacon协议的接口包装。

###### 生命周期接口

- 开始：

```
    [[SensoroSenseHW sharedInstance] startService];
    [[SensoroSenseHW sharedInstance] addObserver:self];
```

- 结束：

```
    [[SensoroSenseHW sharedInstance] stopService];
    [[SensoroSenseHW sharedInstance] removeObserver:self];
```

##### 接口 SNSensoroHWServiceDelegate
接口由观测者来实现。

```
//进入某些传感器的区域。
- (void) onNew: (NSArray*) sensors;
//离开某些传感器的区域。
- (void) onGone: (NSArray*) sensors;
```

相应的类。

- SNSensor

```
uuid //Beacon的UUID;
major //Beacon的major;
minor //Beacon的minor;
key //=uuid+major+minor;
```
