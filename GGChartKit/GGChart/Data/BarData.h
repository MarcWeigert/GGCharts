//
//  BarData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseBarData.h"

typedef enum : NSUInteger {
    DrawBarTopStringAbove,      ///< 顶点上方
    DrawBarTopStringMid,        ///< 顶点中心
    DrawBarTopStringBelow,      ///< 顶点下方
    DrawBarMidStringAbove,      ///< 中点上方
    DrawBarMidStringMid,        ///< 中点中间
    DrawBarMidStringBelow,      ///< 中点下方
    DrawBarBottomStringAbove,   ///< 底点上方
    DrawBarBottomStringMid,     ///< 底点中心
    DrawBarBottomStringBelow,   ///< 低点下方
} BarDrawType;

@interface BarData : BaseBarData

@property (nonatomic, readonly) GGShapeCanvas * barCanvas;  ///< 绘制柱状层

@property (nonatomic, assign) BarDrawType stringDrawType;   ///< 文字绘制区域

/**
 * 绘制柱状图层
 *
 * @param barCanvas 图层
 */
- (void)drawBarWithCanvas:(GGShapeCanvas *)barCanvas;

@end
