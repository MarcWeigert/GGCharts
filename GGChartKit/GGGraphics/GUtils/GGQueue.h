//
//  GGQueue.h
//  GGCharts
//
//  Created by 黄舜 on 2017/11/24.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGQueue : NSObject

/**
 * 队列长度
 */
@property (nonatomic, assign) NSUInteger queueLength;

/**
 * 数组
 */
@property (nonatomic, strong) NSArray * objArray;

/**
 * 极大值
 */
@property (nonatomic, assign, readonly) CGFloat max;

/**
 * 极小值
 */
@property (nonatomic, assign, readonly) CGFloat min;

/**
 * 压入队列
 */
- (void)pushWithRange:(NSRange)range;

/**
 * 压入队列
 */
- (void)push:(NSInteger)index;

/**
 * 取出队列
 */
- (void)pop:(NSInteger)index;

@end
