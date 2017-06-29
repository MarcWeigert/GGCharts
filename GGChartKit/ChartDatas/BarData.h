//
//  BarData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseBarData.h"

typedef enum : NSUInteger {
    BarRectTop,
    BarRectCenter,
    BarRectBottom,
} BarDrawType;

@interface BarData : BaseBarData

@property (nonatomic, readonly) GGShapeCanvas * barCanvas;  ///< 绘制柱状层
@property (nonatomic, readonly) GGCanvas * stringCanvas;    ///< 文字层

@property (nonatomic, copy) NSString * attachedString;
@property (nonatomic, strong) UIFont * stringFont;
@property (nonatomic, strong) UIColor * stringColor;

/**
 * 绘制柱状图层
 *
 * @param barCanvas 图层
 */
- (void)drawBarWithCanvas:(GGShapeCanvas *)barCanvas;

/**
 * 绘制文字
 *
 * @param stringCanvas 静态图层
 * @param tye 绘制类型
 */
- (void)drawBarStringWithCanvas:(GGCanvas *)stringCanvas type:(BarDrawType)tye;

@end
