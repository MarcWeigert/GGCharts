//
//  NSAttributedString+GGChart.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (GGChart)

- (void)setText:(NSString *)text color:(UIColor *)color font:(UIFont *)font;

@end

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

/**
 * 扇形事例图富文本字符串样式
 *
 * @param centerString 中心字符
 * @param subtitle 换行字符
 *
 * @return 富文本字符串
 */
+ (NSAttributedString *)pieCenterStringWithTitle:(NSString *)title
                                        subTitle:(NSString *)subtitle;

/**
 * 扇形事例图富文本字符串样式
 *
 * @param title 标题
 * @param ratio 比例字符串
 * @param price 资金字符串
 * @param ratioColor 比例颜色
 *
 * @return 富文本字符串
 */
+ (NSAttributedString *)pieOutSideStringWithTitle:(NSString *)title
                                            ratio:(NSString *)ratio
                                            price:(NSString *)price
                                       ratioColor:(UIColor *)ratioColor;

@end
