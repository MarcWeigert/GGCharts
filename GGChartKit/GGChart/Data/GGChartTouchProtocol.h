//
//  ChartRespondProtocol.h
//  HSCharts
//
//  Created by _ | Durex on 2017/6/25.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TouchEventMoveNear,
    TouchEventMoveInside,
    TouchEventTapNear,
    TouchEventTapInside
} GGChartEvents;

@protocol GGChartTouchProtocol <NSObject>

@optional

/** 
 * 开始触摸 
 *
 * @param point 手指触碰屏幕的位置
 */
- (void)chartTouchesBegan:(CGPoint)point;

/** 
 * 开始移动 
 *
 * @param point 手指触碰屏幕的位置
 */
- (void)chartTouchesMoved:(CGPoint)point;

@end

