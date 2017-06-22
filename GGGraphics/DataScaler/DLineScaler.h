//
//  DLineScaler.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseScaler.h"

@interface DLineScaler : BaseScaler

@property (nonatomic, assign) CGFloat max;              ///< 区域内最大值
@property (nonatomic, assign) CGFloat min;              ///< 区域内最小值
@property (nonatomic, assign) NSUInteger xMaxCount;     ///< 横向最大点数 默认与数组一致

@property (nonatomic, strong) NSArray <NSNumber *> *dataAry;    ///< 数据
@property (nonatomic, readonly) CGPoint * linePoints;           ///< 数据点

@property (nonatomic, assign) CGFloat xRatio;       ///< x轴偏移比例 0-1 默认 0.5

/** 更新计算点 */
- (void)updateScaler;

/** 获取价格点 */
- (CGFloat)getYPixelWithData:(CGFloat)data;

@end
