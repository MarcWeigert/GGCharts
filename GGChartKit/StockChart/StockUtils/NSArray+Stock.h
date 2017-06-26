//
//  NSArray+Stock.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSArray (Stock)

/** 
 * 获取数组对象的最大值最小值
 *
 * @param max 最大值地址
 * @param min 最小值地址
 * @param getter 对象对比方法
 * @param base 环比最大最小增减比率
 */
- (void)getMax:(CGFloat *)max min:(CGFloat *)min selGetter:(SEL)getter base:(CGFloat)base;

@end
