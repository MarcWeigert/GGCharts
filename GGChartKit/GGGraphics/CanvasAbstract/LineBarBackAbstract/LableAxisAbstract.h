//
//  LableAxisAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef LableAxisAbstract_h
#define LableAxisAbstract_h

#import "BaseAxisAbstract.h"

@protocol LableAxisAbstract <BaseAxisAbstract>

/**
 * 轴纵向显示文字
 */
@property (nonatomic, strong, readonly) NSArray <NSString *> *lables;

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
@property (nonatomic, strong, readonly) NSSet <NSNumber *> * showIndexSet;

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
