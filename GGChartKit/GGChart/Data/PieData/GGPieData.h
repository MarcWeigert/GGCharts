//
//  GGPieData.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PieDrawAbstract.h"
#import "InnerLable.h"
#import "OutSideLable.h"
#import "DPieScaler.h"

@interface GGPieData : NSObject <PieDrawAbstract>

/**
 * 折线图定标器
 */
@property (nonatomic, strong, readonly) DPieScaler * pieScaler;

/**
 * 扇形图
 */
@property (nonatomic, strong) NSArray <NSNumber *> *dataAry;

/**
 * 扇形图半径区间默认{.0f, 100.0f}
 */
@property (nonatomic, assign) GGRadiusRange radiusRange;

/**
 * 扇形图类型
 */
@property (nonatomic, assign) RoseType roseType;

/**
 * 扇形图颜色
 */
@property (nonatomic, copy) UIColor * (^pieColorsForIndex)(NSInteger index, CGFloat ratio);


#pragma mark - Inner

/**
 * 是否显示扇形图文字
 */
@property (nonatomic, assign) BOOL showInnerString;

/**
 * 扇形图内边文字
 */
@property (nonatomic, strong) InnerLable * innerLable;


#pragma mark - OutSide

/**
 * 显示样式
 */
@property (nonatomic, assign) OutSideLableType showOutLableType;

/**
 * 扇形图外边文字
 */
@property (nonatomic, strong) OutSideLable * outSideLable;

@end
