//
//  GGAxisRenderer.h
//  111
//
//  Created by _ | Durex on 2017/5/27.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"

@interface GGAxisRenderer : NSObject <GGRenderProtocol>

/**
 * 轴结构体
 */
@property (nonatomic, assign) GGAxis axis;

/**
 * 线宽度
 */
@property (nonatomic, assign) CGFloat width;

/**
 * 轴颜色
 */
@property (nonatomic, strong) UIColor *color;

/**
 * 是否显示轴线
 */
@property (nonatomic, assign) BOOL showLine;

/**
 * 是否显示轴分割线
 */
@property (nonatomic, assign) BOOL showSep;

/**
 * 文字偏移量
 */
@property (nonatomic, assign) CGSize textOffSet;

/**
 * 轴线文字数组
 */
@property (nonatomic, strong) NSArray <NSString *>* aryString;

/**
 * 轴线文字颜色数组
 */
@property (nonatomic, strong) NSArray <UIColor *>* colorAry;

/**
 * 轴文字颜色
 */
@property (nonatomic, strong) UIColor *strColor;

/**
 * 轴文字字体
 */
@property (nonatomic, strong) UIFont *strFont;

/**
 * 是否显示文字
 */
@property (nonatomic, assign) BOOL showText;

/**
 * 是否绘制在分割中部
 */
@property (nonatomic, assign) BOOL drawAxisCenter;

/**
 * 文字偏移
 */
@property (nonatomic, assign) CGPoint offSetRatio;

/**
 * 文字偏移
 */
@property (nonatomic, assign) NSRange range;

/**
 * 隐藏文字间距
 */
@property (nonatomic, strong) NSArray <NSNumber *> *hiddenPattern;

/**
 * 文字是否首位缩进 默认 NO
 */
@property (nonatomic, assign) BOOL isStringFirstLastindent;

/**
 * 增加轴关键点以及文字
 *
 * @param string 文字
 * @param point 点
 */
- (void)addString:(NSString *)string point:(CGPoint)point;

/**
 * 清除所有附加文字
 */
- (void)removeAllPointString;

/**
 * Block设置轴分割点文字
 *
 * point 关键点 index 索引值 max 最大值
 */
- (void)setStringBlock:(NSString *(^)(CGPoint point, NSInteger index, NSInteger max))stringBlock;

@end
