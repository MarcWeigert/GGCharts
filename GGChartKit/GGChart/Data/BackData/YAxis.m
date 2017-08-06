//
//  YAxis.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "YAxis.h"
#import "NSArray+Stock.h"

@interface YAxis () <AxisAbstract>

@end

@implementation YAxis

- (void)setTitles:(NSArray *)titles
{
    ;
}

- (NSArray *)titles
{
    if (_max == nil || _min == nil) {
        
        return nil;
    }
    
    return [[[NSArray splitWithMax:_max.floatValue
                             min:_min.floatValue
                           split:_splitCount
                          format:@"%.2f"
                        attached:@""] reverseObjectEnumerator] allObjects];
}

- (void)setDrawStringAxisCenter:(BOOL)drawStringAxisCenter
{
    ;
}

- (BOOL)drawStringAxisCenter
{
    return NO;
}

@end
