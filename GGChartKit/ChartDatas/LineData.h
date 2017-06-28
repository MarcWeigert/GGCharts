//
//  LineData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineData.h"

@interface LineData : BaseLineData

@property (nonatomic, readonly) GGShapeCanvas * shapeCanvas;

/**
 * 绘制线图层
 *
 * @param lineCanvas 图层
 */
- (void)drawLineWithCanvas:(GGShapeCanvas *)lineCanvas shapeCanvas:(GGShapeCanvas *)shapeCanvas;

@end
