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

@property (nonatomic, assign) GGAxis axis;      ///< 轴
@property (nonatomic, assign) CGFloat width;        ///< 轴宽度
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, assign) BOOL showLine;    ///< 是否显示轴线
@property (nonatomic, assign) BOOL showSep;         ///< 是否显示轴分割线
@property (nonatomic, assign) CGSize textOffSet;        ///< 文字偏移量

@property (nonatomic, strong) NSArray <NSString *>* aryString;     ///< 文字数组
@property (nonatomic, strong) NSArray <UIColor *>* colorAry;        ///< 文字颜色字符串
@property (nonatomic, strong) UIColor *strColor;                ///< 文字颜色
@property (nonatomic, strong) UIFont *strFont;                      ///< 文字字体
@property (nonatomic, assign) BOOL showText;        ///< 是否显示文字
@property (nonatomic, assign) BOOL drawAxisCenter;          ///< 是否绘制在分割中部
@property (nonatomic, assign) CGPoint offSetRatio;          ///< 文字偏移
@property (nonatomic, assign) NSRange range;            ///< 文字绘制区域
@property (nonatomic, assign) BOOL isStringFirstLastindent;    ///< 文字是否首位缩进 默认 NO

- (void)addString:(NSString *)string point:(CGPoint)point;

- (void)removeAllPointString;

- (void)setStringBlock:(NSString *(^)(CGPoint point, NSInteger index, NSInteger max))stringBlock;

@end
