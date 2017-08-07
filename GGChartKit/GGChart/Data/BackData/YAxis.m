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

@property (nonatomic, assign) CGPoint startLineRatio;

@property (nonatomic, assign) CGPoint endLineRatio;

@end

@implementation YAxis

- (void)setStartLocalRatio:(CGPoint)startLocalRatio
{
    _startLineRatio = startLocalRatio;
}

- (CGPoint)startLocalRatio
{
    return _startLineRatio;
}

- (void)setEndLocalRatio:(CGPoint)endLocalRatio
{
    _endLineRatio = endLocalRatio;
}

- (CGPoint)endLocalRatio
{
    return _endLineRatio;
}

- (void)setTitles:(NSArray *)titles
{
    ;
}

- (NSArray *)titles
{
    if (_max == nil || _min == nil) {
        
        return nil;
    }
    
    if (_splitCount == 0) {
        
        return nil;
    }
    
    NSString *dataFormatter = @"%.2f";
    
    if (_dataFormatter.length) {
        
        dataFormatter = _dataFormatter;
    }
    
    return [[[NSArray splitWithMax:_max.floatValue
                               min:_min.floatValue
                             split:_splitCount
                            format:dataFormatter
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
