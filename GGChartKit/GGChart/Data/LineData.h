//
//  LineData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/28.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineData.h"
#import "GGChartTouchProtocol.h"

@interface LineData : BaseLineData <GGChartTouchProtocol>

@property (nonatomic, assign) BOOL isShowShape;

@property (nonatomic, readonly) GGShapeCanvas * shapeCanvas;

/**
 * 绘制线图层
 *
 * @param lineCanvas 图层
 * @param shapeCanvas 关键点图层
 */
- (void)drawLineWithCanvas:(GGShapeCanvas *)lineCanvas shapeCanvas:(GGShapeCanvas *)shapeCanvas;

/**
 * 增加点击事件
 *
 * @param target 执行类
 * @param action 响应方法 
 * @param controlEvents 点击类型
 *
 * Event: TouchEventMoveNear,
 *        TouchEventTapNear
 *
 * SEL : type1 : CGPoint, type2 : NSInteger
 * 事件方法举例: - (void)onTouchLine:(CGPoint)point index:(NSInteger)index
 */
- (void)addTarget:(id)target
           action:(SEL)action
     forBarEvents:(GGChartEvents)controlEvents;

@end
