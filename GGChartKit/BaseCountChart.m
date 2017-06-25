//
//  BaseCountChart.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseCountChart.h"

#define GGLazyGetMethod(type, attribute)            \
- (type *)attribute                                 \
{                                                   \
if (!_##attribute) {                            \
_##attribute = [[type alloc] init];         \
}                                               \
return _##attribute;                            \
}

@interface BaseCountChart ()

@property (nonatomic, strong) NSMutableArray <UICountingLabel *> * idleLables;         ///< 闲置的图层

@end

@implementation BaseCountChart

- (void)drawChart
{
    [super drawChart];
    
    [self.idleLables addObjectsFromArray:self.visibleLables];
    
    [self.visibleLables enumerateObjectsUsingBlock:^(UICountingLabel * obj, NSUInteger idx, BOOL * stop) {
        
        [obj removeFromSuperview];
    }];
    
    [self.visibleLables removeAllObjects];
}

/**
 * 取图层视图大小与Chart一致
 */
- (UICountingLabel *)getGGCountLable
{
    UICountingLabel * lable = [self makeOrGetCountLable];
    [self addSubview:lable];
    [self.visibleLables addObject:lable];
    return lable;
}

/**
 * 获取图层
 */
- (UICountingLabel *)makeOrGetCountLable
{
    UICountingLabel * lable = [self.idleLables firstObject];
    
    if (lable == nil) {
        
        lable = [[UICountingLabel alloc] init];
    }
    else {
        
        [self.idleLables removeObject:lable];
    }
    
    return lable;
}

GGLazyGetMethod(NSMutableArray, visibleLables);

GGLazyGetMethod(NSMutableArray, idleLables);

@end
