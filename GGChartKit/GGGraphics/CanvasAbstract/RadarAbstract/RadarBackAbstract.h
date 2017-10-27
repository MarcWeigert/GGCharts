//
//  RadarBackAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef RadarBackAbstract_h
#define RadarBackAbstract_h

@protocol RadarBackAbstract <NSObject>

/**
 * 雷达图顶点字符串
 */
@property (nonatomic, strong, readonly) NSArray <NSString *> * titles;

/**
 * 线颜色
 */
@property (nonatomic, strong, readonly) UIColor * strockColor;

/**
 * 字符串颜色
 */
@property (nonatomic, strong, readonly) UIColor * stringColor;

/**
 * 背景视图分割
 */
@property (nonatomic, assign, readonly) NSUInteger splitCount;

/**
 * 字体
 */
@property (nonatomic, strong, readonly) UIFont * titleFont;

/**
 * 线宽
 */
@property (nonatomic, assign, readonly) CGFloat lineWidth;

/**
 * 最外层雷达线宽度
 */
@property (nonatomic, assign, readonly) CGFloat borderWidth;

/**
 * 半径
 */
@property (nonatomic, assign, readonly) CGFloat radius;

/**
 * 文字与顶点间距
 */
@property (nonatomic, assign, readonly) CGFloat titleSpacing;

/**
 * 是否背景为圆形
 */
@property (nonatomic, assign) BOOL isCirlre;

@property (nonatomic, assign, readonly) NSInteger side;

@end


#endif /* RadarBackAbstract_h */
