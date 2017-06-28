//
//  DBarScaler.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "DLineScaler.h"

typedef void(^BarRects)(CGRect *rects, size_t size);

@interface DBarScaler : DLineScaler

@property (nonatomic, assign) CGFloat bottomPrice;  ///< 柱状图底部价格点默认0

@property (nonatomic, assign) CGFloat barWidth;     ///< 柱宽

@property (nonatomic, readonly) CGRect * barRects;    ///< bar 绘制位置

/** 正数的rect */
- (void)getPositiveData:(BarRects)block;

/** 负数的rect */
- (void)getNegativeData:(BarRects)block;

@end
