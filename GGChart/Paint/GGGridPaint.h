//
//  GGGrid.h
//  HSCharts
//
//  Created by 黄舜 on 16/12/30.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGDrawerProtocol.h"

@class GGAxis;

/**
 * 网格结构
 * x 横向分割
 * y 纵向分割
 */
typedef struct CGGrid{
    NSUInteger x, y;
}CGGrid;

CG_INLINE CGGrid CGGridMake(NSUInteger x, NSUInteger y) {
    CGGrid grid = {x, y};
    return grid;
}

@interface GGGridPaint : NSObject <GGLayerProtocal>

@property (nonatomic, assign) CGRect rect;  ///< 网格区域
@property (nonatomic, assign) CGGrid grid;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIColor *color;

/** 初始化 */
- (instancetype)initWithRect:(CGRect)rect grid:(CGGrid)grid;
+ (instancetype)gridWithRect:(CGRect)rect grid:(CGGrid)grid;

/** 增加轴 */
- (void)addAxisForX:(GGAxis *)axis;
- (void)addAxisForY:(GGAxis *)axis;

@end

/**
 * 轴结构
 * left, right 轴两边超出网格多少像素
 * weight 轴在网格中所代表权重, 0.5代表在中心位置
 * split 轴分割线长度
 */
typedef struct CGAxis{
    CGFloat left, right;
    CGFloat weight;
    CGFloat split;
}CGAxis;

CG_INLINE CGAxis CGAxisMake(CGFloat weight, CGFloat split, CGFloat left, CGFloat right) {
    CGAxis axis = {left, right, weight, split};
    return axis;
}

@interface GGAxis : NSObject

/** 轴文字 */
@property (nonatomic, strong) NSArray <NSString *>* titles;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGAxis axis;

/** 初始化 */
- (instancetype)initWithCGAxis:(CGAxis)axis;
+ (instancetype)axisWithCGAxis:(CGAxis)axis;

@end
