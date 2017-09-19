//
//  PieDrawAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef PieDrawAbstract_h
#define PieDrawAbstract_h

#include "PieOutSideLableAbstract.h"

typedef enum : NSUInteger {
    RoseNormal,
    RoseRadius,
} RoseType;

typedef enum : NSUInteger {
    OutSideNormal,
    OutSideShow,
    OutSideSelect,
} OutSideLableType;

@protocol PieDrawAbstract <NSObject>

/**
 * 扇形图结构体
 */
@property (nonatomic, assign, readonly) GGPie * pies;

/**
 * 扇形图比例
 */
@property (nonatomic, assign, readonly) CGFloat * ratios;

/**
 * 扇形图
 */
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *dataAry;

/**
 * 扇形图类型
 */
@property (nonatomic, assign, readonly) RoseType roseType;

/**
 * 扇形图颜色
 */
@property (nonatomic, copy, readonly) UIColor * (^pieColorsForIndex)(NSInteger index, CGFloat ratio);


#pragma mark - Inner

/**
 * 是否显示扇形图文字
 */
@property (nonatomic, assign, readonly) BOOL showInnerString;

/**
 * 扇形图内边文字
 */
@property (nonatomic, strong, readonly) id <PieInnerLableAbstract> innerLable;


#pragma mark - OutSide

/**
 * 显示样式
 */
@property (nonatomic, assign, readonly) OutSideLableType showLableType;

/**
 * 扇形图外边文字
 */
@property (nonatomic, strong, readonly) id <PieOutSideLableAbstract> outSideLable;

@end

#endif /* PieDrawAbstract_h */
