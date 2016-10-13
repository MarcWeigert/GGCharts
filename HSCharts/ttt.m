//
//  ttt.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/8.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "ttt.h"
#import <objc/runtime.h>

@implementation ttt

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    NSLog(@"begin : %@", event);
    
    return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(nullable UIEvent *)event
{
    NSLog(@"end : %@", event);
    
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
}

@end
