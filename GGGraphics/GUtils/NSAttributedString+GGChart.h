//
//  NSAttributedString+GGChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSAttributedString (GGChart)

/**
 * 扇形事例图富文本字符串样式
 *
 * @param name 扇形图名字
 * @param nameColor 颜色
 * @param title 扇形图说明
 * @param fractional 分数
 *
 * @return 富文本字符串
 */
+ (NSAttributedString *)pieChartWeightAttributeStringWith:(NSString *)name
                                                nameColor:(UIColor *)nameColor
                                                    title:(NSString *)title
                                               fractional:(NSString *)fractional;

/**
 * 扇形事例图富文本字符串样式
 *
 * @param largeString 大字符
 * @param smallString 小字符
 *
 * @return 富文本字符串
 */
+ (NSAttributedString *)pieInnerStringWithLargeString:(NSString *)largeString
                                          smallString:(NSString *)smallString;

/**
 * 扇形事例图富文本字符串样式
 *
 * @param centerString 中心字符
 * @param smallString 小字符
 *
 * @return 富文本字符串
 */
+ (NSAttributedString *)pieInnerStringWithCenterString:(NSString *)centerString
                                           smallString:(NSString *)smallString;

@end
