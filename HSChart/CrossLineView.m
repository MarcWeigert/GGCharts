//
//  CrossLineView.m
//  HSCharts
//
//  Created by 黄舜 on 16/6/27.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "CrossLineView.h"
#import "SawGraph.h"

@interface CrossLineView ()

@property (nonatomic) CALayer *topLayer;

@property (nonatomic) CALayer *bottomLayer;

@property (nonatomic) BoardLayer *backgroundLayer;

@property (nonatomic) NSArray <NSString *> *topBaseAry;

@property (nonatomic) NSArray <NSString *> *bottomBaseAry;

@end

@implementation CrossLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _topLayer = [[CALayer alloc] init];
        _bottomLayer = [[CALayer alloc] init];
        _backgroundLayer = [[BoardLayer alloc] init];
        
        [self setFrame:frame];
        [_backgroundLayer addSublayer:_bottomLayer];
        [_backgroundLayer addSublayer:_topLayer];
        [self.layer addSublayer:_backgroundLayer];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _topLayer.frame = CGRectMake(30, 20, _backgroundLayer.width - 60, _backgroundLayer.height - 40);
    _bottomLayer.frame = CGRectMake(30, 20, _backgroundLayer.width - 60, _backgroundLayer.height - 40);
}

- (void)loadViewData
{
    float top_max = getMax(_topAry);
    float top_min = getMin(_topAry);
    float bottom_max = getMax(_bottomAry);
    float bottom_min = getMax(_bottomAry);
    
    top_min = top_min > 0 ? 0 : top_min;
    bottom_min = bottom_min > 0 ? 0 : bottom_min;
    
    NSArray *aryTop = makeBaseAry(top_max, top_min);
    NSArray *aryBottom = makeBaseAry(bottom_max, bottom_min);
    NSMutableArray *aryTxtTop = [NSMutableArray array];
    NSMutableArray *aryTxtBottom = [NSMutableArray array];
    
    _topLayer.max = [aryTop.lastObject floatValue];
    _topLayer.min = [aryTop.firstObject floatValue];
    _bottomLayer.max = [aryBottom.lastObject floatValue];
    _bottomLayer.min = [aryBottom.firstObject floatValue];
    
    for (NSNumber *number in aryTop) {
        
        [aryTxtTop addObject:number.stringValue];
    }
    
    for (NSNumber *number in aryBottom) {
        
        [aryTxtBottom addObject:number.stringValue];
    }
    
    _topBaseAry = [NSArray arrayWithArray:aryTxtTop];
    _bottomBaseAry = [NSArray arrayWithArray:aryTxtBottom];
}

- (void)loadBackGroundLayer
{
    PaintBrush *drawer = [[PaintBrush alloc] init];
    drawer.stockClr = [UIColor blackColor];
    drawer.width = 0.8;
    drawer.font = [UIFont systemFontOfSize:_topLayer.frame.size.width / self.bounds.size.width * 9];
    
    [drawer drawStart:_topLayer.topLeft end:_topLayer.lowerLeft];
    [drawer drawStart:_topLayer.lowerRight end:_topLayer.topRight];
    [drawer drawStart:_topLayer.lowerRight end:_topLayer.lowerLeft];
    
    CGFloat interval_x = _bottomLayer.width / _titleAry.count;
    CGFloat interval_ly = _bottomLayer.height / (_bottomBaseAry.count - 1);
    CGFloat interval_ry = _bottomLayer.height / (_topBaseAry.count - 1);
    NSArray *bottomAry = [[_bottomBaseAry reverseObjectEnumerator] allObjects];
    
    for (NSInteger i = 0; i < _titleAry.count; i++) {
        
        NSString *txt = _titleAry[i];
        CGFloat offset = (i + 1) * interval_x;
        CGPoint start = OFFSET_X(_bottomLayer.lowerLeft, offset);
        CGPoint end = OFFSET_Y(start, 3);
        CGPoint textPt = CGPointMake(_bottomLayer.left + interval_x * i + interval_x / 2, end.y + 1);
        
        [drawer drawStart:start end:end];
        [drawer drawTxt:txt atBottom:textPt];
    }
    
    for (NSInteger i = 0; i < _bottomBaseAry.count; i++) {
        
        CGFloat offset = interval_ly * i;
        CGPoint start = OFFSET_Y(_bottomLayer.topLeft, offset);
        CGPoint end = OFFSET_X(start, -3);
        CGPoint textPt = OFFSET_X(end, -1);
        
        [drawer drawStart:start end:end];
        [drawer drawTxt:bottomAry[i] atLeft:textPt];
    }
    
    for (NSInteger i = 0; i < _topBaseAry.count; i++) {
        
        CGFloat offset = interval_ry * i;
        CGPoint start = OFFSET_Y(_bottomLayer.topRight, offset);
        CGPoint end = OFFSET_X(start, 3);
        CGPoint textPt = OFFSET_X(end, 1);
        
        [drawer drawStart:start end:end];
        [drawer drawTxt:_topBaseAry[i] atRight:textPt];
    }
    
    [_backgroundLayer drawWithBrush:drawer];
}

- (void)loadLineLayer
{
    [_topLayer draw_updateSpiders:^(GraphSpider *make) {
        
        make.drawLine.fillColor(_topFillColor).drawAry([_topAry reverseObjectEnumerator].allObjects).rounder(0);
        make.drawLine.drawAry([_topAry reverseObjectEnumerator].allObjects).color(_topLineColor).witdth(0.6);
    }];
    
    [_bottomLayer draw_updateSpiders:^(GraphSpider *make) {
        
        make.drawLine.fillColor(_bottomFillColor).drawAry(_bottomAry).rounder(0);
        make.drawLine.drawAry(_bottomAry).color(_bottomLineColor).witdth(0.6);
    }];
    
    [_topLayer setAnchorPoint:CGPointMake(0.5, 0.5)];
    _topLayer.affineTransform = CGAffineTransformMakeRotation(M_PI);
}

- (void)stockChart
{
    [self loadViewData];
    
    [self loadLineLayer];
    [self loadBackGroundLayer];
}

- (void)addAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 3;
    
    [_topLayer addAnimationForSubLayers:animation];
    [_bottomLayer addAnimationForSubLayers:animation];
}

@end
