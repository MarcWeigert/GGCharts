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
@property (nonatomic, readonly) GGCanvas * stringCanvas;

@property (nonatomic, copy) NSString * attachedString;
@property (nonatomic, strong) UIFont * stringFont;
@property (nonatomic, strong) UIColor * stringColor;
@property (nonatomic, copy) NSString * format;

/**
 * 绘制线图层
 *
 * @param lineCanvas 图层
 * @param shapeCanvas 关键点图层
 */
- (void)drawLineWithCanvas:(GGShapeCanvas *)lineCanvas shapeCanvas:(GGShapeCanvas *)shapeCanvas;

/**
 * 绘制文字层
 *
 * @param stringCanvas 文字
 */
- (void)drawStringWithCanvas:(GGCanvas *)stringCanvas;

@end
