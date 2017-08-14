//
//  XAxis.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "XAxis.h"

@interface XAxis () <AxisAbstract>

@property (nonatomic, assign) CGPoint startLineRatio;

@property (nonatomic, assign) CGPoint endLineRatio;

@property (nonatomic, assign) CGSize xAxisTextOffset;        ///< 偏移量

@end

@implementation XAxis

- (void)setAxisName:(id<AxisTitleAbstract>)axisName
{

}

- (id<AxisTitleAbstract>)axisName
{
    return nil;
}

- (void)setTextOffset:(CGSize)textOffset
{
    _xAxisTextOffset = textOffset;
}

- (CGSize)textOffset
{
    return _xAxisTextOffset;
}

- (void)setOffset:(CGFloat)offset
{
    _offset = offset;
    
    _xAxisTextOffset = CGSizeMake(0, _offset);
}

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

@end
