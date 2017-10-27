//
//  NumberData.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumberAbstract.h"

@interface NumberData : NSObject <NumberAbstract>

/**
 * 外部文字字体颜色
 */
@property (nonatomic, strong) UIColor * lableColor;

/**
 * 外部文字字体
 */
@property (nonatomic, strong) UIFont * lableFont;

/**
 * 扇形图内边文字格式化字符串
 */
@property (nonatomic, strong) NSString * stringFormat;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign) CGPoint stringRatio;

/**
 * 文字偏移
 */
@property (nonatomic, assign) CGSize stringOffSet;

/**
 * 富文本字符串
 */
@property (nonatomic, copy) NSAttributedString *(^attrbuteStringValueBlock)(CGFloat value);

@end
