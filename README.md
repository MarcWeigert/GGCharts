## 图表示例
| 样例一 | 样例二
|------------|------------
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/LineChart1.GIF?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/BarChart1.GIF?raw=true)
| 样例三 | 样例四
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/LineChart2.GIF?raw=true) | ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/LineBarChart1.GIF?raw=true)
| 样例五 | 样例六
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/PieChart1.gif?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/PieChart2.GIF?raw=true)
| 样例七 | 样例八
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/RadarChat1.PNG?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/ProgressChart1.GIF?raw=true)

## 折线图与柱状图
### 支持特性:
- 支持数据拉伸、并列、居中对齐、堆叠、正负堆叠(同级数据叠加)、指定数据环绕。
- 支持折线区域填充颜色以及渐变色。
- 支持自定义折线或者柱状图文字字体、颜色、偏移量。
- 支持更新时支持渐变动画。
- 支持自定义网格线宽、颜色、虚线样式。
- 支持自定义X轴Y轴字体、颜色、文字偏移量，Y轴标题文字。
- 支持柱状图或折线图指定轴数据(默认左边Y轴)
- 支持自动计算Y轴极大值极小值、可设置极大极小值偏移比率。
- 支持自定义Y轴极大值极小值。

### 数据结构:
![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/LineBarUML.png?raw=true)

### 折线与柱状图 DataSet :
#### 共有属性 BaseLineBarSet
```objective-c
/**
 * 折线与柱状图内边距
 */
@property (nonatomic, assign) UIEdgeInsets insets;

/**
 * 折线与柱状图背景层设置
 */
@property (nonatomic, strong) LineBarGird * gridConfig;

/**
 * 折线与柱状表现形式
 */
@property (nonatomic, assign) LineBarDataMode lineBarMode;

/**
 * 数据中极大极小值偏移比率, 默认0.1
 */
@property (nonatomic, assign) CGFloat idRatio;

/**
 * 更新时是否需要动画
 */
@property (nonatomic, assign) BOOL updateNeedAnimation;

/**
 * 柱状图折线图数据文字颜色
 * 优先级高于 data.stringColor
 *
 * @param value 数据
 *
 * @return 柱状图颜色
 */
@property (nonatomic, copy) UIColor *(^stringColorForValue)(CGFloat value);
```

> 注意：BaseLineBarSet 中属性`insets` 为数据背景网格边框的内边距。

#### 柱状图 BarDataSet
```objective-c
/**
 * 柱状图颜色
 * 优先级高于 BarData.fillColor
 *
 * @param indexPath 柱状位置
 * @param number 柱状图数据
 *
 * @return 柱状图颜色
 */
@property (nonatomic, copy) UIColor *(^barColorsAtIndexPath)(NSIndexPath *indexPath, NSNumber * number);

/**
 * 柱状图数据数组
 */
@property (nonatomic, strong) NSArray <BarData *> *barAry;

/**
 * 中间分割线线宽
 */
@property (nonatomic, assign) CGFloat midLineWidth;

/**
 * 中间线颜色
 */
@property (nonatomic, strong) UIColor * midLineColor;
```
#### 折线图 LineDataSet
```objective-c
/**
 * 折线图数据数组
 */
@property (nonatomic, strong) NSArray <LineData *> * lineAry;
```
###折线与柱状图 Data :
#### 共有属性 BaseLineBarData
```objective-c
/**
 * 柱状图, 折线定标器
 */
@property (nonatomic, strong, readonly) DLineScaler * lineBarScaler;

/**
 * 用来显示的数据
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dataAry;

/**
 * 柱状, 折线定标轴, 默认左轴
 */
@property (nonatomic, assign) ScalerAxisMode scalerMode;

/**
 * 围绕该Y轴坐标点填充, FLT_MIN 代表不填充
 */
@property (nonatomic, strong) NSNumber * roundNumber;

/**
 * 环绕Y轴像素点
 */
@property (nonatomic, assign, readonly) CGFloat bottomYPix;

#pragma mark - 折线文字

/**
 * 柱状, 折线文字字体
 */
@property (nonatomic, strong) UIFont * stringFont;

/**
 * 柱状, 折线文字颜色
 */
@property (nonatomic, strong) UIColor * stringColor;

/**
 * 柱状, 折线格式化字符串
 */
@property (nonatomic, strong) NSString * dataFormatter;

/**
 * 折线文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 柱状, 折线文字偏移
 */
@property (nonatomic, assign) CGSize stringOffset;
```

> 注意：BaseLineBarData 中属性`offSetRatio` 如果没有特别比例要求，可以参考 GGGraphicsConstants 已经写好的偏移比率

```objective-c
/**
 * 文字偏移比例
 */
CG_EXTERN CGPoint const GGRatioTopLeft;
CG_EXTERN CGPoint const GGRatioTopCenter;
CG_EXTERN CGPoint const GGRatioTopRight;

CG_EXTERN CGPoint const GGRatioBottomLeft;
CG_EXTERN CGPoint const GGRatioBottomCenter;
CG_EXTERN CGPoint const GGRatioBottomRight;

CG_EXTERN CGPoint const GGRatioCenterLeft;
CG_EXTERN CGPoint const GGRatioCenter;
CG_EXTERN CGPoint const GGRatioCenterRight;
```
#### 折线 LineData
```objective-c
#pragma mark - 折线配置
/**
 * 折线线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 折线颜色
 */
@property (nonatomic, strong) UIColor * lineColor;

/**
 * 折线虚线样式
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dashPattern;

/**
 * 显示关键点设置
 */
@property (nonatomic, strong) NSSet <NSNumber *> * showShapeIndexSet;


#pragma mark - 折线关键点配置

/**
 * 折线关键点半径
 */
@property (nonatomic, assign) CGFloat shapeRadius;

/**
 * 折线关键点填充色
 */
@property (nonatomic, strong) UIColor * shapeFillColor;

/**
 * 折线线宽
 */
@property (nonatomic, assign) CGFloat shapeLineWidth;


#pragma mark - 折线填充

/**
 * 折线填充色, 优先级比渐变色高
 */
@property (nonatomic, strong) UIColor * lineFillColor;

/**
 * 折线填充渐变色, 数据内传入CGColor
 */
@property (nonatomic, strong) NSArray * gradientFillColors;

/**
 * 填充色变化曲线, 由上至下
 */
@property (nonatomic, strong) NSArray <NSNumber *> *locations;
```
#### 柱状 BarData
```objective-c
/**
 * 柱状图边框颜色
 */
@property (nonatomic, strong) UIColor * barBorderColor;

/**
 * 柱状图填充色
 */
@property (nonatomic, strong) UIColor * barFillColor;

/**
 * 柱状图边框
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * 柱状图宽度
 */
@property (nonatomic, assign) CGFloat barWidth;
```
### 背景与轴 Data :
#### 网格 LineBarGird
```objective-c
/**
 * 轴线结构体
 */
@property (nonatomic, assign) GGLine axisLine;

/**
 * 轴纵向显示文字
 */
@property (nonatomic, strong) NSArray <NSString *> *lables;

/**
 * 轴线分割线长度
 */
@property (nonatomic, assign) CGFloat over;

/**
 * 文字与轴之间的间距
 */
@property (nonatomic, assign) CGFloat stringGap;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 是否绘制在分割线中心点
 */
@property (nonatomic, assign) BOOL drawStringAxisCenter;

/**
 * 隐藏文字间隔
 */
@property (nonatomic, strong) NSArray <NSNumber *> * hiddenPattern;

/**
 * 显示文字标签集合, 设置改选项 hiddenPattern 失效
 */
@property (nonatomic, strong) NSSet <NSNumber *> * showIndexSet;

/**
 * 是否显示轴网格线
 */
@property (nonatomic, assign) BOOL showSplitLine;

/**
 * 是否显示查价标
 */
@property (nonatomic, assign) BOOL showQueryLable;
```
#### 数据轴 YAxis
```objective-c
/**
 * 轴最大值
 */
@property (nonatomic, strong) NSNumber * max;

/**
 * 轴最小值
 */
@property (nonatomic, strong) NSNumber * min;

/**
 * 轴线结构体
 */
@property (nonatomic, assign) GGLine axisLine;

/**
 * 轴格式化字符串
 */
@property (nonatomic, strong) NSString * dataFormatter;

/**
 * Y轴分割个数
 */
@property (nonatomic, assign) NSUInteger splitCount;

/**
 * 轴线分割线长度
 */
@property (nonatomic, assign) CGFloat over;

/**
 * 文字与轴之间的间距
 */
@property (nonatomic, assign) CGFloat stringGap;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 是否显示轴网格线
 */
@property (nonatomic, assign) BOOL showSplitLine;

/**
 * 是否显示查价标
 */
@property (nonatomic, assign) BOOL showQueryLable;

/**
 * 轴标题
 */
@property (nonatomic, strong) AxisName * name;
```
#### 标签轴 XAxis
```objective-c

/**
 * 轴纵向显示文字
 */
@property (nonatomic, strong) NSArray <NSString *> *lables;

/**
 * 轴线分割线长度
 */
@property (nonatomic, assign) CGFloat over;

/**
 * 文字与轴之间的间距
 */
@property (nonatomic, assign) CGFloat stringGap;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 是否绘制在分割线中心点
 */
@property (nonatomic, assign) BOOL drawStringAxisCenter;

/**
 * 隐藏文字间隔
 */
@property (nonatomic, strong) NSArray <NSNumber *> * hiddenPattern;

/**
 * 显示文字标签集合, 设置改选项 hiddenPattern 失效
 */
@property (nonatomic, strong) NSSet <NSNumber *> * showIndexSet;

/**
 * 是否显示轴网格线
 */
@property (nonatomic, assign) BOOL showSplitLine;
```

## 股票图表示例
| 配色白 | 配色黑
|------------|------------
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart1.PNG?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/IMG_2939.jpeg?raw=true)
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart2.PNG?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart6.GIF?raw=true)
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart3.PNG?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart5.GIF?raw=true)
