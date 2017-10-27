//
//  BaseIndexLayer.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KLineIndexManager.h"
#import "DKLineScaler.h"
#import "GGGraphics.h"

@interface BaseIndexLayer : GGCanvas

@property (nonatomic, strong) NSArray <NSDictionary *> *datas;

@property (nonatomic, assign) CGFloat currentKLineWidth;

/**
 * 绘制折线
 *
 * @param dictionary 绘制数据格式 @[@{@"MA5" : xxx, @"MA10" : xxx}, ...]
 * @param keys 数据对象 @[@"MA5", @"MA10", ...]
 * @param colorForKeys 绘制数据对应颜色 @{@"MA5" : [UIColor red], @"MA10", ...};
 */
- (void)registerLinesForDictionary:(NSArray <NSDictionary *> *)dictionary
                              keys:(NSArray *)keys
                      colorForKeys:(NSDictionary *)colorForKeys;

/**
 * 绘制柱状图
 *
 * @param dictionary 绘制数据格式 @[@{@"MA5" : xxx, @"MA10" : xxx}, ...]
 * @param key 绘制标签
 * @param positiveColor 正数颜色
 * @param negativeColor 负数颜色
 */
- (void)registerBarsForDictionary:(NSArray <NSDictionary *> *)dictionary
                              key:(NSString *)key
                    positiveColor:(UIColor *)positiveColor
                    negativeColor:(UIColor *)negativeColor;


/**
 * 绘制层数据(线)
 */
- (void)updateLineLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min;

/**
 * 绘制层数据(柱)
 */
- (void)updateBarLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min;

/**
 * 获取区间最大值最小值
 */
- (void)getIndexWithRange:(NSRange)range max:(CGFloat *)max min:(CGFloat *)min;

#pragma mark - 子类重写

/**
 * 更新title
 */
- (NSArray <NSString *> *)titles;

/**
 * 
 */
- (NSAttributedString *)attrStringWithIndex:(NSInteger)index;

/**
 * 更新指标图表
 */
- (void)setKLineArray:(NSArray <id<KLineAbstract, VolumeAbstract>> *)kLineArray;

/**
 * 绘制指标层
 */
- (void)updateLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min;

@end
