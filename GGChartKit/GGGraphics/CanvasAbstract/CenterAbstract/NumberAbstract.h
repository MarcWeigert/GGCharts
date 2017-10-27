//
//  NumberAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef NumberAbstract_h
#define NumberAbstract_h

@protocol NumberAbstract <NSObject>

/**
 * 外部文字字体颜色
 */
@property (nonatomic, strong, readonly) UIColor * lableColor;

/**
 * 外部文字字体
 */
@property (nonatomic, strong, readonly) UIFont * lableFont;

/**
 * 扇形图内边文字格式化字符串
 */
@property (nonatomic, strong, readonly) NSString * stringFormat;

/**
 * 文字偏移比例
 *
 * {0, 0} 中心, {-1, -1} 右上, {0, 0} 左下
 *
 * {-1, -1}, { 0, -1}, { 1, -1},
 * {-1,  0}, { 0,  0}, { 1,  0},
 * {-1,  1}, { 0,  1}, { 1,  1},
 */
@property (nonatomic, assign, readonly) CGPoint stringRatio;

/**
 * 文字偏移
 */
@property (nonatomic, assign, readonly) CGSize stringOffSet;

@optional

/**
 * 富文本字符串
 */
@property (nonatomic, copy, readonly) NSAttributedString *(^attrbuteStringValueBlock)(CGFloat value);

@end

#endif /* NumberAbstract_h */
