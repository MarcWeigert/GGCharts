//
//  XAxis.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XAxis : NSObject

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

@end
