//
//  QueryAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef QueryAbstract_h
#define QueryAbstract_h

#import "NumberAxisAbstract.h"
#import "LableAxisAbstract.h"
#import "BaseLineBarAbstract.h"

@protocol QueryAbstract <NSObject>

#pragma mark - 轴设置

/**
 * 查价层左边数据轴
 */
@property (nonatomic, weak, readonly) id <NumberAxisAbstract> leftNumberAxis;

/**
 * 查价层右边数据轴
 */
@property (nonatomic, weak, readonly) id <NumberAxisAbstract> rightNumberAxis;

/**
 * 查价层上层标签轴
 */
@property (nonatomic, weak, readonly) id <LableAxisAbstract> topLableAxis;

/**
 * 查价层下层标签轴
 */
@property (nonatomic, weak, readonly) id <LableAxisAbstract> bottomLableAxis;


#pragma mark - 查价设置

/**
 * 查价层内边距
 */
@property (nonatomic, assign, readonly) UIEdgeInsets insets;

/**
 * 查价层线宽
 */
@property (nonatomic, assign, readonly) CGFloat lineWidth;

/**
 * 查价层线颜色
 */
@property (nonatomic, strong, readonly) UIColor * lineColor;

/**
 * 查价虚线设置
 */
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *dashPattern;


#pragma mark - 查价文字设置

/**
 * 查价文字内边距
 */
@property (nonatomic, assign, readonly) UIEdgeInsets lableInsets;

/**
 * 查价文字字体
 */
@property (nonatomic, strong, readonly) UIFont * lableFont;

/**
 * 查价文字颜色
 */
@property (nonatomic, strong, readonly) UIColor * lableColor;

/**
 * 查价背景颜色
 */
@property (nonatomic, strong, readonly) UIColor * lableBackgroundColor;

/**
 * 查价标签弧度
 */
@property (nonatomic, assign, readonly) CGFloat lableRadius;

@end

#endif /* QueryAbstract_h */
