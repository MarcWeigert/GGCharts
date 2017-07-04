//
//  BaseStockChart.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseStockChart.h"
#import "GGChartDefine.h"

NSString * const GGKeyPathContentOffset = @"contentOffset";

@implementation BaseStockChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _scrollView.backgroundColor = [UIColor grayColor];
        [self addSubview:_scrollView];
        
        [self addObservers];
    }
    
    return self;
}

- (void)setVolumRect:(CGRect)rect
{
    self.redVolumLayer.frame = rect;
    self.greenVolumLayer.frame = rect;
    self.volumScaler.rect = rect;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _scrollView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)dealloc
{
    [self removeObservers];
}

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    
}

- (BOOL)volumIsRed:(id)obj
{
    return NO;
}

#pragma mark - KVO监听

- (void)addObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self.scrollView addObserver:self forKeyPath:GGKeyPathContentOffset options:options context:nil];
}

- (void)removeObservers
{
    [self removeObserver:self forKeyPath:GGKeyPathContentOffset];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:GGKeyPathContentOffset]) {
        
        [self scrollViewContentSizeDidChange:change];
    }
}

#pragma mark - Lazy

GGLazyGetMethod(CAShapeLayer, redVolumLayer);
GGLazyGetMethod(CAShapeLayer, greenVolumLayer);
GGLazyGetMethod(DBarScaler, volumScaler);

@end
