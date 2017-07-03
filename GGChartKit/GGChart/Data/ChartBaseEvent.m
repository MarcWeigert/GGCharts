//
//  ChartBaseEvent.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/25.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "ChartBaseEvent.h"

@interface ChartBaseEvent ()

@property (nonatomic, copy) NSString * selectorName;    ///< 方法名

@property (nonatomic, weak) id target;      ///< 接受者

@end

@implementation ChartBaseEvent

+ (instancetype)eventWithTarget:(id)target action:(SEL)action
{
    ChartBaseEvent * event = [self new];
    event.selectorName = NSStringFromSelector(action);
    event.target = target;
    event.imp = [target methodForSelector:action];
    return event;
}

- (SEL)eventAction
{
    return NSSelectorFromString(_selectorName);
}

- (id)eventTarget
{
    return _target;
}

@end
