//
//  PNBarData.h
//  HSCharts
//
//  Created by _ | Durex on 2017/6/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseBarData.h"

@interface PNBarData : BaseBarData

@property (nonatomic, strong) UIColor * positiveColor;      ///< 正数的颜色
@property (nonatomic, strong) UIColor * negativeColor;      ///< 负数的颜色

@property (nonatomic, weak, readonly) GGShapeCanvas * pBarCanvas;    ///< 正数图层
@property (nonatomic, weak, readonly) GGShapeCanvas * nBarCanvas;    ///< 负数图层

/**
 * 绘制柱状图层
 *
 * @param pBarCanvas 正数柱图层
 * @param nBarCanvas 负数柱图层
 */
- (void)drawPNBarWithCanvas:(GGShapeCanvas *)pBarCanvas negativeCanvas:(GGShapeCanvas *)nBarCanvas;

@end
