//
//  BaseStockChart.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGraphics.h"

@interface BaseStockChart : UIView <UIScrollViewDelegate>

@property (nonatomic, readonly) UIScrollView * scrollView;  ///< 滚动视图

@property (nonatomic, strong) DBarScaler * volumScaler;   ///< 成交量定标器

@property (nonatomic, strong) CAShapeLayer * redVolumLayer;   ///< 红色成交量
@property (nonatomic, strong) CAShapeLayer * greenVolumLayer;     ///< 绿色成交量

@property (nonatomic, strong, readonly) GGCanvas * stringLayer;      ///< k线back
@property (nonatomic, strong, readonly) UIScrollView * backScrollView;  ///< 背景滚动

/** 
 * 视图滚动 
 */
- (void)scrollViewContentSizeDidChange;

/** 
 * 设置成交量层
 *
 * @param rect redVolumLayer.frame = rect; greenVolumLayer.frame = rect
 */
- (void)setVolumRect:(CGRect)rect;

/** 
 * 成交量视图是否为红色 
 *
 * @parm obj volumScaler.lineObjAry[idx]
 */
- (BOOL)volumIsRed:(id)obj;

/**
 * 局部更新成交量
 *
 * range 成交量更新k线的区域, CGRangeMAx(range) <= volumScaler.lineObjAry.count
 */
- (void)updateVolumLayer:(NSRange)range;

@end
