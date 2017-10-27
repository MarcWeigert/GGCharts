//
//  BaseStockChart.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseStockChart.h"

NSString * const GGKeyPathContentOffset = @"contentOffset";

@interface BaseStockChart ()

@end

@implementation BaseStockChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _stringLayer = [[GGCanvas alloc] init];
        _stringLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        
        _backScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _backScrollView.showsHorizontalScrollIndicator = NO;
        _backScrollView.showsVerticalScrollIndicator = NO;
        _backScrollView.userInteractionEnabled = NO;
        [self addSubview:_backScrollView];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView.layer addSublayer:self.redVolumLayer];
        [_scrollView.layer addSublayer:self.greenVolumLayer];
        [self addSubview:_scrollView];

        [self.layer addSublayer:_stringLayer];
    }
    
    return self;
}

/**
 * 设置成交量层
 *
 * @param rect redVolumLayer.frame = rect; greenVolumLayer.frame = rect
 */
- (void)setVolumRect:(CGRect)rect
{
    self.redVolumLayer.frame = rect;
    self.greenVolumLayer.frame = rect;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _backScrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _stringLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

/**
 * 视图滚动
 */
- (void)scrollViewContentSizeDidChange
{
    CGPoint contentSize = self.scrollView.contentOffset;
    
    if (_scrollView.contentOffset.x < 0) {
        
        contentSize = CGPointMake(0, 0);
    }
    
    if (_scrollView.contentOffset.x + _scrollView.frame.size.width > _scrollView.contentSize.width) {
        
        contentSize = CGPointMake(_scrollView.contentSize.width - _scrollView.frame.size.width, 0);
    }
    
    [self.backScrollView setContentOffset:contentSize];
}

/**
 * 成交量视图是否为红色
 *
 * @parm obj volumScaler.lineObjAry[idx]
 */

- (BOOL)volumIsRed:(id)obj
{
    return NO;
}

/**
 * 局部更新成交量
 *
 * range 成交量更新k线的区域, CGRangeMAx(range) <= volumScaler.lineObjAry.count
 */
- (void)updateVolumLayer:(NSRange)range
{
    CGMutablePathRef refRed = CGPathCreateMutable();
    CGMutablePathRef refGreen = CGPathCreateMutable();
    
    for (NSInteger i = range.location; i < NSMaxRange(range); i++) {
        
        CGRect shape = self.volumScaler.barRects[i];
        NSObject * obj = self.volumScaler.lineObjAry[i];
        [self volumIsRed:obj] ? GGPathAddCGRect(refRed, shape) : GGPathAddCGRect(refGreen, shape);
    }
    
    self.redVolumLayer.path = refRed;
    CGPathRelease(refRed);
    
    self.greenVolumLayer.path = refGreen;
    CGPathRelease(refGreen);
}

#pragma mark - Lazy

GGLazyGetMethod(CAShapeLayer, redVolumLayer);
GGLazyGetMethod(CAShapeLayer, greenVolumLayer);
GGLazyGetMethod(DBarScaler, volumScaler);

@end
