简介
==============
-  一组简洁的图表库HSChats。
-  数据中宏:FLT_MIN代表空值(不绘制)。
-  图表线宽, 柱宽, 直径等已View的大小适配。
-  图表注入多组数据时, 要注意每组数据长度是否一致。
-  图表数据均用数组的形式注入, 避免使用对象复杂化。
-  图表均用HSGrapth框架绘制, 该框架的使用在另一篇ReadMe介绍。
-  Version: 1.0.0
-  咨询QQ: 2755643709
-  开发作者: 黄舜

要求
==============
* iOS 7.0 or later
* Xcode 8.0 or later

集成
==============
* 手工集成:
  -  【Objective-C】: 导入文件夹HSChart以及HSGraph

使用
==============
### 空心饼图

<img src = "https://github.com/huangshun11/Charts/blob/master/Image/imgHollowFanView.png" width = "375">

```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    HollowFanView *fanView = [[HollowFanView alloc] initWithFrame:CGRectZero];
    fanView.frame = CGRectMake(0, 0, 300, 300);
    fanView.dataAry = @[@335, @310, @234, @135, @1548];
    fanView.titleAry = @[@"直接访问", @"邮件营销", @"联盟广告", @"视频广告", @"搜索引擎"];
    fanView.colorAry = @[__RGB_RED, __RGB_BLUE, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN];
    [fanView stockChart];
    
    [self.view addSubview:fanView];
}
```

### 普通饼图
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    PieView *pieView = [[PieView alloc] initWithFrame:CGRectZero];
    pieView.frame = CGRectMake(0, 0, 370, 370);
    pieView.dataAry = @[@335, @310, @234, @135, @1548];
    pieView.titleAry = @[@"直接访问", @"邮件营销", @"联盟广告", @"视频广告", @"搜索引擎"];
    pieView.colorAry = @[__RGB_RED, __RGB_BLUE, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN];
    [pieView stockChart];
    
    [self.view addSubview:pieView];
}
```

### 数据堆叠柱状图
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CumSumBarView *layView = [[CumSumBarView alloc] initWithFrame:CGRectZero];
    layView.frame =  CGRectMake(10, 100, self.view.frame.size.width - 10, 400);
    layView.colorAry = @[__RGB_RED, __RGB_GREEN, __RGB_BLUE, __RGB_ORIGE, __RGB_CYAN];
    layView.dataArys = @[@[@320, @202, @301, @334, @390, @330, @320],
                         @[@120, @132, @101, @134, @90, @230, @210],
                         @[@220, @182, @191, @234, @290, @330, @310],
                         @[@150, @212, @201, @154, @190, @330, @410],
                         @[@820, @832, @901, @934, @1290, @1330, @1320]];
    layView.titleAry = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    [layView stockChart];
    
    [self.view addSubview:layView];
}
```

### 数据排列柱状图
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    RankBarView *rankBar = [[RankBarView alloc] initWithFrame:CGRectZero];
    rankBar.frame =  CGRectMake(0, 100, self.view.frame.size.width, 400);
    rankBar.colorAry = @[__RGB_RED, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN];
    rankBar.titleAry = @[@"1月", @"2月", @"3月", @"4月", @"5月", @"6月", @"7月", @"8月", @"9月", @"10月", @"11月", @"12月"];
    rankBar.dataArys = @[@[@(FLT_MIN), @(FLT_MIN), @7.0, @23.2, @25.6, @76.7, @135.6, @162.2, @32.6, @20.0, @6.4, @3.3],
                         @[@2.6, @5.9, @9.0, @26.4, @28.7, @70.7, @175.6, @182.2, @48.7, @18.8, @6.0, @2.3]];
    
    [rankBar stockChart];
    
    [self.view rankBar];
}
```

### 堆叠区域折线图
```objective-c
- (void)viewDidLoad {
    [super viewDidLoad];
    
    CumSumLineView *layView = [[CumSumLineView alloc] initWithFrame:CGRectZero];
    layView.frame =  CGRectMake(10, 100, self.view.frame.size.width - 10, 400);
    layView.colorAry = @[__RGB_RED, __RGB_GREEN, __RGB_BLUE, __RGB_ORIGE, __RGB_CYAN];
    layView.dataArys = @[@[@320, @202, @301, @334, @390, @330, @320],
                         @[@120, @132, @101, @134, @90, @230, @210],
                         @[@220, @182, @191, @234, @290, @330, @310],
                         @[@150, @212, @201, @154, @190, @330, @410],
                         @[@820, @832, @901, @934, @1290, @1330, @1320]];
    layView.titleAry = @[@"周一", @"周二", @"周三", @"周四", @"周五", @"周六", @"周日"];
    [layView stockChart];
    
    [self.view addSubview:layView];
}
```

## <a id="期待"></a>期待

- 如果您在使用过程中有任何问题，欢迎issue me! 很乐意为您解答任何相关问题!
- 与其给我点star，不如向我狠狠地抛来一个BUG！
- 如果您想要更多的接口来自定义或者建议/意见，欢迎issue me！我会全力满足大家！

## Licenses
All source code is licensed under the MIT License.

