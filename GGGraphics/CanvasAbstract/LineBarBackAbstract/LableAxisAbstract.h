//
//  LableAxisAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef LableAxisAbstract_h
#define LableAxisAbstract_h

@protocol LableAxisAbstract <NSObject>

/**
 * 轴线结构体
 */
@property (nonatomic, assign, readonly) GGLine axisLine;

/**
 * 轴纵向显示文字
 */
@property (nonatomic, strong, readonly) NSArray <NSString *> *lables;

/**
 * 轴线分割线长度
 */
@property (nonatomic, assign, readonly) CGFloat over;

/**
 * 文字与轴之间的间距
 */
@property (nonatomic, assign, readonly) CGFloat stringGap;

/**
 * 轴文字偏移比例
 *
 * {0, 0} 数据点左下方绘制, {-0.5, -0.5} 数据点中心绘制, {-1, -1} 数据点右上方绘制
 */
@property (nonatomic, assign, readonly) CGPoint offSetRatio;

/**
 * 是否绘制在分割线中心点
 */
@property (nonatomic, assign, readonly) BOOL drawStringAxisCenter;

/**
 * 隐藏文字间隔
 */
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *hiddenPattern;

/**
 * 显示文字标签集合, 设置改选项 hiddenPattern 失效
 */
@property (nonatomic, strong, readonly) NSSet *showIndexSet;

/**
 * 是否显示分割线
 */

/**
 * 通过像素点获取轴向文字
 *
 * @param pix 像素点
 *
 * @return 文字
 */
- (NSString *)getLablesPix:(CGFloat)pix;

@end

#endif /* LableAxisAbstract_h */
