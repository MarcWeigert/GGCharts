//
//  NSObject+GraDispose.h
//  HCharts
//
//  Created by 黄舜 on 16/6/16.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@class GraphSpider;

@interface CALayer (GraDispose)

@property (nonatomic) CGFloat max;      ///< 层内最高值

@property (nonatomic) CGFloat min;      ///< 层内最低值

/** 所有一级子层添加动画 */
- (void)addAnimationForSubLayers:(CAAnimation *)ani;

/** 子层加动画, 子层位置 */
- (void)addAnimation:(CAAnimation *)ani layerIndex:(NSInteger)index;

/** 直接绘制 */
- (NSArray *)draw_makeSpiders:(void (^) (GraphSpider *make))block;

/** 更新绘制 */
- (NSArray *)draw_updateSpiders:(void (^) (GraphSpider *make))block;

/** 清空层在绘制 */
- (NSArray *)draw_remakeSpiders:(void (^) (GraphSpider *make))block;

@end
