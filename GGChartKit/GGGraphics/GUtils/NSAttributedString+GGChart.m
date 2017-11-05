//
//  NSAttributedString+GGChart.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NSAttributedString+GGChart.h"

@implementation NSMutableAttributedString (GGChart)

- (void)setText:(NSString *)text color:(UIColor *)color font:(UIFont *)font
{
    NSRange range = [self.string rangeOfString:text];
    
    [self addAttribute:NSForegroundColorAttributeName  //文字颜色
                 value:color
                 range:range];
    
    [self addAttribute:NSFontAttributeName             //文字字体
                 value:font
                 range:range];
}

@end

@implementation NSAttributedString (GGChart)

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
+ (NSAttributedString *)pieChartWeightAttributeStringWith:(NSString *)name nameColor:(UIColor *)nameColor title:(NSString *)title fractional:(NSString *)fractional
{
    NSString * string = [NSString stringWithFormat:@"%@%@\n%@", name, fractional, title];
    NSMutableAttributedString * attrbuteString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrbuteString setText:name color:nameColor font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(15)]];
    [attrbuteString setText:fractional color:C_HEX(0x767676) font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(8)]];
    [attrbuteString setText:title color:C_HEX(0x343843) font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(11)]];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByWordWrapping;
    paraStyle.lineSpacing = 5;
    [attrbuteString addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, string.length)];
    
    return attrbuteString;
}

/**
 * 扇形事例图富文本字符串样式
 *
 * @param largeString 大字符
 * @param smallString 小字符
 *
 * @return 富文本字符串
 */
+ (NSAttributedString *)pieInnerStringWithLargeString:(NSString *)largeString smallString:(NSString *)smallString
{
    NSString * string = [NSString stringWithFormat:@"%@%@", largeString, smallString];
    NSMutableAttributedString * attrbuteString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrbuteString setText:largeString color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:GG_SIZE_CONVERT(16)]];
    [attrbuteString setText:smallString color:[UIColor whiteColor] font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(11)]];
    
    return attrbuteString;
}

/**
 * 扇形事例图富文本字符串样式
 *
 * @param centerString 中心字符
 * @param smallString 小字符
 *
 * @return 富文本字符串
 */
+ (NSAttributedString *)pieInnerStringWithCenterString:(NSString *)centerString smallString:(NSString *)smallString
{
    NSString * string = [NSString stringWithFormat:@"%@\n%@", centerString, smallString];
    NSMutableAttributedString * attrbuteString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrbuteString setText:centerString color:C_HEX(0x333333) font:[UIFont boldSystemFontOfSize:GG_SIZE_CONVERT(23)]];
    [attrbuteString setText:smallString color:C_HEX(0x686868) font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(10)]];
    
    return attrbuteString;
}

/**
 * 扇形事例图富文本字符串样式
 *
 * @param centerString 中心字符
 * @param subtitle 换行字符
 *
 * @return 富文本字符串
 */
+ (NSAttributedString *)pieCenterStringWithTitle:(NSString *)title subTitle:(NSString *)subtitle
{
    NSString * string = [NSString stringWithFormat:@"%@\n%@", title, subtitle];
    NSMutableAttributedString * attrbuteString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrbuteString setText:title color:[UIColor whiteColor] font:[UIFont boldSystemFontOfSize:GG_SIZE_CONVERT(16)]];
    [attrbuteString setText:subtitle color:[UIColor whiteColor] font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(16)]];
    
    return attrbuteString;
}

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
+ (NSAttributedString *)pieOutSideStringWithTitle:(NSString *)title ratio:(NSString *)ratio price:(NSString *)price ratioColor:(UIColor *)ratioColor
{
    NSString * string = [NSString stringWithFormat:@"%@\n%@\n%@", title, ratio, price];
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:3];
    
    [attrString setText:title color:[UIColor blackColor] font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(10)]];
    [attrString setText:ratio color:ratioColor font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(16)]];
    [attrString setText:price color:[UIColor blackColor] font:[UIFont systemFontOfSize:GG_SIZE_CONVERT(10)]];
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
    
    return attrString;
}

@end
