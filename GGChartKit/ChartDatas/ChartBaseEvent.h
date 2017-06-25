//
//  ChartBaseEvent.h
//  HSCharts
//
//  Created by _ | Durex on 2017/6/25.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChartBaseEvent : NSObject

@property (nonatomic) void * imp;       ///< 方法指针

@property (nonatomic, readonly) SEL eventAction;    ///< 点击方法

@property (nonatomic, readonly) id eventTarget;     ///< 响应者

/**
 * 创建点击事件
 *
 * @param target 响应者
 * @param action 方法
 *
 * @return event 事件
 */
+ (instancetype)eventWithTarget:(id)target action:(SEL)action;

@end
