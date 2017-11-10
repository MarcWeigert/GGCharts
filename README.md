# GGChart
**目录 (Table of Contents)**

*   [GGChart](#GGChart)
    *   [图表示例](##%e5%9b%be%e8%a1%a8%e7%a4%ba%e4%be%8b)
    *   [折线图与柱状图](#%e6%8a%98%e7%ba%bf%e5%9b%be%e4%b8%8e%e6%9f%b1%e7%8a%b6%e5%9b%be)
        *   [折线图柱状图支持特性](#%e6%8a%98%e7%ba%bf%e5%9b%be%e6%9f%b1%e7%8a%b6%e5%9b%be%e6%94%af%e6%8c%81%e7%89%b9%e6%80%a7)
        *   [折线图柱状图数据结构](#%e6%8a%98%e7%ba%bf%e5%9b%be%e6%9f%b1%e7%8a%b6%e5%9b%be%e6%95%b0%e6%8d%ae%e7%bb%93%e6%9e%84)
		*   [折线与柱状图DataSet](#%e6%8a%98%e7%ba%bf%e4%b8%8e%e6%9f%b1%e7%8a%b6%e5%9b%beDataSet)
			*   [BaseLineBarSet](#BaseLineBarSet)
			*   [BarDataSet:BaseLineBarSet](#BarDataSet:BaseLineBarSet)
			*   [LineDataSet:BaseLineBarSet](#LineDataSet:BaseLineBarSet)
		*   [折线与柱状图Data:](#%e6%8a%98%e7%ba%bf%e4%b8%8e%e6%9f%b1%e7%8a%b6%e5%9b%beData:)
			*   [BaseLineBarData](#BaseLineBarData)
			*   [LineData:BaseLineBarData](#LineData:BaseLineBarData)
			*   [BarData:BaseLineBarData](#BarData:BaseLineBarData)
		*   [背景与轴:](#%e8%83%8c%e6%99%af%e4%b8%8e%e8%bd%b4:)
			*   [LineBarGird](#LineBarGird)
			*   [YAxis](#YAxis)
			*   [YAxis](#YAxis)
    *   [饼图](#饼图)
        *   [饼图支持特性:](#%e9%a5%bc%e5%9b%be%e6%94%af%e6%8c%81%e7%89%b9%e6%80%a7:)
        *   [饼图数据结构:](#%e9%a5%bc%e5%9b%be%e6%95%b0%e6%8d%ae%e7%bb%93%e6%9e%84:)
		*   [饼图属性列表:](#%e9%a5%bc%e5%9b%be%e5%b1%9e%e6%80%a7%e5%88%97%e8%a1%a8:)
			*   [PieDataSet](#PieDataSet)
			*   [PieData](#PieData)
			*   [NumberData](#NumberData)
			*   [InnerLable : NumberData](#InnerLable : NumberData)
			*   [OutSideLable：InnerLable](#OutSideLable：InnerLable)
			*   [CenterLableData：NumberData](#CenterLableData：NumberData)
			*   [CenterData](#CenterData)
  *   [雷达图](#%e9%9b%b7%e8%be%be%e5%9b%be)
        *   [雷达图支持特性:](#%e9%9b%b7%e8%be%be%e5%9b%be%e6%94%af%e6%8c%81%e7%89%b9%e6%80%a7:)
        *   [雷达图数据结构:](#%e9%9b%b7%e8%be%be%e5%9b%be%e6%95%b0%e6%8d%ae%e7%bb%93%e6%9e%84:)
		*   [雷达图属性列表:](#%e9%9b%b7%e8%be%be%e5%9b%be%e5%b1%9e%e6%80%a7%e5%88%97%e8%a1%a8:)
			*   [RadarDataSet](#RadarDataSet)
			*   [RadarIndicatorData](#RadarIndicatorData)
			*   [RadarData](#RadarData)
  *   [进度条图](#进度条图)
        *   [进度条图支持特性:](#%e8%bf%9b%e5%ba%a6%e6%9d%a1%e5%9b%be%e6%94%af%e6%8c%81%e7%89%b9%e6%80%a7:)
        *   [进度条图数据结构:](#%e8%bf%9b%e5%ba%a6%e6%9d%a1%e5%9b%be%e6%95%b0%e6%8d%ae%e7%bb%93%e6%9e%84:)
		*   [进度条图属性列表:](#%e8%bf%9b%e5%ba%a6%e6%9d%a1%e5%9b%be%e5%b1%9e%e6%80%a7%e5%88%97%e8%a1%a8:)
			*   [ProgressData](#ProgressData)
			*   [ProgressData:NumberData](#ProgressData:NumberData)
  *   [股票图表示例](#%e8%82%a1%e7%a5%a8%e5%9b%be%e8%a1%a8%e7%a4%ba%e4%be%8b)

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
### 折线图柱状图支持特性
- 支持数据拉伸、并列、居中对齐、堆叠、正负堆叠(同级数据叠加)、指定数据环绕。
- 支持折线区域填充颜色以及渐变色。
- 支持自定义折线或者柱状图文字字体、颜色、偏移量。
- 支持更新时支持渐变动画。
- 支持自定义网格线宽、颜色、虚线样式。
- 支持自定义X轴Y轴字体、颜色、文字偏移量，Y轴标题文字。
- 支持柱状图或折线图指定轴数据(默认左边Y轴)
- 支持自动计算Y轴极大值极小值、可设置极大极小值偏移比率。
- 支持自定义Y轴极大值极小值。

### 折线图柱状图数据结构
![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/LineBarUML.png?raw=true)

### 折线与柱状图DataSet
#### BaseLineBarSet
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

#### BarDataSet:BaseLineBarSet
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
#### LineDataSet:BaseLineBarSet
```objective-c
/**
 * 折线图数据数组
 */
@property (nonatomic, strong) NSArray <LineData *> * lineAry;
```
### 折线与柱状图Data
#### BaseLineBarData
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
#### LineData:BaseLineBarData
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
#### BarData:BaseLineBarData
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
### 背景与轴:
#### LineBarGird
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
#### YAxis
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
#### XAxis
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

## 饼图
### 饼图支持特性:
- 支持渐变色。
- 支持点击。
- 支持数据更新渐变动画。
- 支持根据数据大小比例伸缩。
- 支持扇形与环形绘制。
- 支持扇形内部，与外部文字(字体，颜色，偏移量)。
- 支持扇形外线。(直接展示，点击展示)。

### 饼图数据结构:
![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/PieUML.png?raw=true)

### 饼图属性列表:
#### PieDataSet
```objective-c
/**
 * 扇形图数组
 */
@property (nonatomic, strong) NSArray <PieData *> * pieAry;

/**
 * 是否显示中心标签
 */
@property (nonatomic, assign) BOOL showCenterLable;

/**
 * 中心点
 */
@property (nonatomic, strong) CenterData * centerLable;

/**
 * 扇形图边框宽度
 */
@property (nonatomic, assign) CGFloat pieBorderWidth;

/**
 * 环形间距
 */
@property (nonatomic, assign) CGFloat borderRadius;

/**
 * 扇形图边框颜色
 */
@property (nonatomic, strong) UIColor * pieBorderColor;

/**
 * 更新时是否需要动画
 */
@property (nonatomic, assign) BOOL updateNeedAnimation;
```

#### PieData
```objective-c
/**
 * 折线图定标器
 */
@property (nonatomic, strong, readonly) DPieScaler * pieScaler;

/**
 * 扇形图开始角度默认12点钟方向
 */
@property (nonatomic, assign) CGFloat pieStartTransform;

/**
 * 扇形图
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dataAry;

/**
 * 扇形图半径区间默认{.0f, 100.0f}
 */
@property (nonatomic, assign) GGRadiusRange radiusRange;

/**
 * 扇形图类型
 */
@property (nonatomic, assign) RoseType roseType;

/**
 * 扇形图颜色
 */
@property (nonatomic, copy) UIColor * (^pieColorsForIndex)(NSInteger index, CGFloat ratio);

/**
 * 渐变色权重
 */
@property (nonatomic, strong) NSArray <NSNumber *> *gradientLocations;

/**
 * 颜色渐变曲线
 */
@property (nonatomic, assign) GradientCurve gradientCurve;

/**
 * 渐变色, 优先级高于UIColor * (^pieColorsForIndex)(NSInteger index, CGFloat ratio)
 */
@property (nonatomic, copy) NSArray <UIColor *> * (^gradientColorsForIndex)(NSInteger index);

#pragma mark - Inner

/**
 * 是否显示扇形图文字
 */
@property (nonatomic, assign) BOOL showInnerString;

/**
 * 扇形图内边文字
 */
@property (nonatomic, strong) InnerLable * innerLable;

#pragma mark - OutSide

/**
 * 显示样式
 */
@property (nonatomic, assign) OutSideLableType showOutLableType;

/**
 * 扇形图外边文字
 */
@property (nonatomic, strong) OutSideLable * outSideLable;
```

> 注意：PieData 中属性`radiusRange`  为结构体 `struct GGRadiusRange
{ CGFloat inRadius; CGFloat outRadius; }`，要求 outRadius需要包含inRadius。详见类`GGPie` 。

#### NumberData
```objective-c
/**
 * 外部文字字体颜色
 */
@property (nonatomic, strong) UIColor * lableColor;

/**
 * 外部文字字体
 */
@property (nonatomic, strong) UIFont * lableFont;

/**
 * 扇形图内边文字格式化字符串
 */
@property (nonatomic, strong) NSString * stringFormat;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint stringRatio;

/**
 * 文字偏移
 */
@property (nonatomic, assign) CGSize stringOffSet;

/**
 * 富文本字符串
 */
@property (nonatomic, copy) NSAttributedString *(^attrbuteStringValueBlock)(CGFloat value);
```

#### InnerLable:NumberData
```objective-c
/**
 * 扇形图富文本字符串
 */
@property (nonatomic, copy) NSAttributedString * (^attributeStringBlock)(NSInteger index, CGFloat value, CGFloat ratio);
```

#### OutSideLable:InnerLable
```objective-c
/**
 * 线宽度
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 折线与扇形图的间距
 */
@property (nonatomic, assign) CGFloat lineSpacing;

/**
 * 线长度
 */
@property (nonatomic, assign) CGFloat lineLength;

/**
 * 拐弯线长度
 */
@property (nonatomic, assign) CGFloat inflectionLength;

/**
 * 拐点线终点圆形半径
 */
@property (nonatomic, assign) CGFloat linePointRadius;

/**
 * 折线颜色
 */
@property (nonatomic, copy) UIColor * (^lineColorsBlock)(NSInteger index, CGFloat ratio);
```

#### CenterLableData:NumberData
```objective-c
/**
 * 中间数字
 */
@property (nonatomic, assign) CGFloat number;
```
#### CenterData
```objective-c
/**
 * 填充颜色
 */
@property (nonatomic, strong) UIColor * fillColor;

/**
 * 结构体
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * 中间文字配置
 */
@property (nonatomic, strong) CenterLableData * lable;
```

## 雷达图
### 雷达图支持特性:
- 支持自定义雷达图背景，圆环或者多边形。
- 支持自定义文字(字体，颜色，偏移量)。
- 支持自定义背景线(颜色，现款)。
- 支持雷达内容渐变色。

### 雷达图数据结构:
![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/RadarUML.png?raw=true)

### 雷达图属性列表:

> 注意：雷达图需要先制定各个维度最大值以及标题，详见`RadarIndicatorData`。

#### RadarDataSet
```objective-c
/**
 * 图层数据
 */
@property (nonatomic, strong) NSArray <RadarData *> * radarSet;

/**
 * 基础摄制
 */
@property (nonatomic, strong) NSArray <RadarIndicatorData *> * indicatorSet;

/**
 * 背景雷达线颜色
 */
@property (nonatomic, strong) UIColor * strockColor;

/**
 * 分割数
 */
@property (nonatomic, assign) NSUInteger splitCount;

/**
 * 标题字体
 */
@property (nonatomic, strong) UIFont * titleFont;

/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 雷达图半径
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * 文字与顶点间距
 */
@property (nonatomic, assign) CGFloat titleSpacing;

/**
 * 最外层雷达线宽度
 */
@property (nonatomic, assign) CGFloat borderWidth;

/**
 * 是否背景为圆形
 */
@property (nonatomic, assign) BOOL isCirlre;

/**
 * 文字颜色
 */
@property (nonatomic, strong) UIColor * stringColor;
```
#### RadarIndicatorData
```objective-c
/**
 * 标题
 */
@property (nonatomic, strong) NSString * title;

/**
 * 最大值
 */
@property (nonatomic, assign) CGFloat max;
```

#### RadarData
```objective-c
/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

/**
 * 填充颜色
 */
@property (nonatomic, strong) UIColor *fillColor;

/**
 * 线颜色
 */
@property (nonatomic, strong) UIColor *strockColor;

/**
 * 基础长度比例, 当数据为0时最低雷达图显示位置
 */
@property (nonatomic, assign) CGFloat baseRatio;

/**
 * 数据源
 */
@property (nonatomic, strong) NSArray <NSNumber *> *datas;

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

#pragma mark - Gradient

/**
 * 渐变色
 */
@property (nonatomic, strong) NSArray * gradientColors;
```

## 进度条图
### 进度条图支持特性:
- 支持自定义启示角度
- 支持自定义文字(字体、颜色)。
- 支持更新动画。
- 支持渐变色。

### 进度条图数据结构:
![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/ProgressUML.png?raw=true)

###  进度条图属性列表:
#### ProgressData
```objective-c
/**
 * 最大值
 */
@property (nonatomic, assign) CGFloat maxValue;

/**
 * 当前值
 */
@property (nonatomic, assign) CGFloat value;

#pragma mark - 进度条范围

/**
 * 开始角度
 *
 * 3点方向为0度(水平为0度)
 */
@property (nonatomic, assign) CGFloat startAngle;

/**
 * 结束角度
 */
@property (nonatomic, assign) CGFloat endAngle;

#pragma mark - 进度条设置

/**
 * 进度条背景颜色
 */
@property (nonatomic, strong) UIColor * progressBackColor;

/**
 * 进度条渐变色
 */
@property (nonatomic, strong) NSArray <UIColor *> * progressGradientColor;

/**
 * 渐变色权重
 */
@property (nonatomic, strong) NSArray <NSNumber *> *gradientLocations;

/**
 * 渐变色曲线
 */
@property (nonatomic, assign) GradientCurve gradientCurve;

/**
 * 进度条半径
 */
@property (nonatomic, assign) CGFloat progressRadius;

/**
 * 小圆点弧度
 */
@property (nonatomic, assign) CGFloat pointRadius;

/**
 * 小圆颜色
 */
@property (nonatomic, strong) UIColor * pointColor;

/**
 * 线宽
 */
@property (nonatomic, assign) CGFloat lineWidth;

#pragma mark - 中心文字设置

/**
 * 中心文字外观设置
 */
@property (nonatomic, strong) ProgressLable * centerLable;
```
#### ProgressData:NumberData
```objective-c
--
```


## 股票图表示例
| 配色白 | 配色黑
|------------|------------
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart1.PNG?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/IMG_2939.jpeg?raw=true)
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart2.PNG?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart6.GIF?raw=true)
| ![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart3.PNG?raw=true) |![enter image description here](https://github.com/MarcWeigert/Show-HSCharts-Images/blob/master/GGCharts/StockChart5.GIF?raw=true)
