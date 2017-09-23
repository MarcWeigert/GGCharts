//
//  BaseAxisAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef BaseAxisAbstract_h
#define BaseAxisAbstract_h

@protocol BaseAxisAbstract <NSObject>

/**
 * 轴线结构体
 */
@property (nonatomic, assign, readonly) GGLine axisLine;

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
 * 是否显示查价标
 */
@property (nonatomic, assign, readonly) BOOL showQueryLable;

@end

#endif /* BaseAxisAbstract_h */
