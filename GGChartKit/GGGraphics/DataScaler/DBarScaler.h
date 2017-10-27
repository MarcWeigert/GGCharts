//
//  DBarScaler.h
//  HSCharts
//
//  Created by _ | Durex on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "DLineScaler.h"

typedef void(^BarRects)(CGRect *rects, size_t size);

@interface DBarScaler : DLineScaler

/**
 * 柱宽
 */
@property (nonatomic, assign) CGFloat barWidth;

/**
 * Rect结构体指针
 */
@property (nonatomic, readonly) CGRect * barRects;

/** 
 * 正数的rect 
 */
- (void)getPositiveData:(BarRects)block range:(NSRange)range;

/**
 * 负数的rect 
 */
- (void)getNegativeData:(BarRects)block range:(NSRange)range;

/**
 * 正数的rect 
 */
- (void)getPositiveData:(BarRects)block;

/** 
 * 负数的rect 
 */
- (void)getNegativeData:(BarRects)block;

@end
