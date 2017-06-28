//
//  BarData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseBarData.h"

@interface BarData : BaseBarData

@property (nonatomic, readonly) GGShapeCanvas * barCanvas;  ///< 绘制柱状层

/**
 * 绘制柱状图层
 *
 * @param barCanvas 图层
 */
- (void)drawBarWithCanvas:(GGShapeCanvas *)barCanvas;

@end
