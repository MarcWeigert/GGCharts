//
//  BaseBrush.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "BaseBrush.h"

@implementation BaseBrush

/** 初始化绘制区域 */
- (id)initWithArray:(NSMutableArray *)muAry drawFrame:(CGRect)frame
{
    self = [super init];
    
    if (self) {
        
        _array = muAry;
        _drawFrame = frame;
    }
    
    return self;
}

/** 构造绘制函数 */
- (void (^)())draw
{
    return ^{
        
        // 构造绘制函数放入数组
    };
}

@end
