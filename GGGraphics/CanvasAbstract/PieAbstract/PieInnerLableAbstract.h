//
//  PieInnerLableAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef PieInnerLableAbstract_h
#define PieInnerLableAbstract_h

@protocol PieInnerLableAbstract <NSObject>

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
 */
@property (nonatomic, assign, readonly) CGPoint stringRatio;

/**
 * 文字偏移
 */
@property (nonatomic, assign, readonly) CGSize stringOffSet;

/**
 * 扇形图富文本字符串
 */
@property (nonatomic, copy, readonly) NSAttributedString * (^attributeStringBlock)(NSInteger index, CGFloat ratio);

@end


#endif /* PieInnerLableAbstract_h */
