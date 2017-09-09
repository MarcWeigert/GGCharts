//
//  YNumberAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef NumberAxisAbstract_h
#define NumberAxisAbstract_h

#pragma mark - 数字轴标题

@protocol NumberAxisNameAbstract <NSObject>

/**
 * 标题文字
 */
@property (nonatomic, strong, readonly) NSString * string;

/**
 * 标题文字字体
 */
@property (nonatomic, strong, readonly) UIFont * font;

/**
 * 标题文字颜色
 */
@property (nonatomic, strong, readonly) UIColor * color;

/**
 * 轴文字偏移比例
 *
 * {0, 0} 数据点左下方绘制, {-0.5, -0.5} 数据点中心绘制, {-1, -1} 数据点右上方绘制
 */
@property (nonatomic, assign, readonly) CGPoint offSetRatio;

/**
 * 标题文字偏移量
 */
@property (nonatomic, assign, readonly) CGSize offSetSize;

@end

#pragma mark - 数字轴

@protocol NumberAxisAbstract <NSObject>

/**
 * 轴线结构体
 */
@property (nonatomic, assign, readonly) GGLine axisLine;

/**
 * 轴格式化字符串
 */
@property (nonatomic, strong, readonly) NSString * dataFormatter;

/**
 * Y轴分割个数
 */
@property (nonatomic, assign, readonly) NSUInteger splitCount;

/**
 * 轴线分割线长度
 */
@property (nonatomic, assign, readonly) CGFloat over;

/**
 * 文字与轴之间的间距
 */
@property (nonatomic, assign, readonly) CGFloat stringGap;

/**
 * 轴文字偏移比例
 *
 * {0, 0} 数据点左下方绘制, {-0.5, -0.5} 数据点中心绘制, {-1, -1} 数据点右上方绘制
 */
@property (nonatomic, assign, readonly) CGPoint offSetRatio;

/**
 * 是否显示轴网格线
 */
@property (nonatomic, assign, readonly) BOOL showSplitLine;

/**
 * 轴标题
 */
@property (nonatomic, assign, readonly) id <NumberAxisAbstract> name;

/**
 * 通过轴线当前长度获取数据
 *
 * @param pix 像素
 *
 * @return 数据
 */
- (CGFloat)getNumberWithPix:(CGFloat)pix;

@end

#endif /* NumberAxisAbstract_h */
