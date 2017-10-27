//
//  BaseLineBarCanvasAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/15.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef BaseLineBarCanvasAbstract_h
#define BaseLineBarCanvasAbstract_h

@protocol BaseLineBarCanvasAbstract <NSObject>

/**
 * 更新时是否需要动画
 */
@property (nonatomic, assign, readonly) BOOL updateNeedAnimation;

/**
 * 柱状图颜色
 * 优先级高于 stringColor
 *
 * @param value 数据
 *
 * @return 柱状图颜色
 */
@property (nonatomic, copy, readonly) UIColor *(^stringColorForValue)(CGFloat value);

@end

#endif /* BaseLineBarCanvasAbstract_h */
