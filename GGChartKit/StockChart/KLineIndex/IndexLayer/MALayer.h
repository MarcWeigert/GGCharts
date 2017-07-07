//
//  MALayer.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseIndexLayer.h"
#import "KLineAbstract.h"

@interface MALayer : BaseIndexLayer

/**
 * 根据数组数据结构计算MA指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param MA 参数 @[@5, @10, @20, @40]
 */
- (void)updateIndexWithArray:(NSArray <id<KLineAbstract>> *)kLineArray
                       param:(NSDictionary <NSNumber *, UIColor *> *)param;

/**
 * 绘制层数据
 */
- (void)updateLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min;

@end
