//
//  CumSumLineView.m
//  HSCharts
//
//  Created by 黄舜 on 16/6/28.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "CumSumLineView.h"
#import "SawGraph.h"
#import "Colors.h"

@interface CumSumLineView ()

@property (nonatomic) CALayer *lineLayer;

@property (nonatomic) BoardLayer *backgroundLayer;

@property (nonatomic) BoardLayer *roundLayer;

@property (nonatomic) NSArray <NSString *> *baseAry;

@end

@implementation CumSumLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _lineLayer = [[CALayer alloc] init];
        _backgroundLayer = [[BoardLayer alloc] init];
        _roundLayer = [[BoardLayer alloc] init];
        
        [self setFrame:frame];
        [_backgroundLayer addSublayer:_lineLayer];
        [_backgroundLayer addSublayer:_roundLayer];
        [self.layer addSublayer:_backgroundLayer];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _lineLayer.frame = CGRectMake(30, 20, _backgroundLayer.width - 40, _backgroundLayer.height - 40);
    _roundLayer.frame = _lineLayer.frame;
}

- (void)loadViewData
{
    NSArray *sumAry = aryAddup(_dataArys);
    
    float max = getAryMax(sumAry);
    float min = getAryMin(sumAry);
    
    NSArray *baseAry = makeBaseAry(max, min);
    NSMutableArray *aryStr = [NSMutableArray array];
    
    _lineLayer.max = [[baseAry lastObject] floatValue];
    _lineLayer.min = [[baseAry firstObject] floatValue];
    
    for (NSNumber *number in baseAry) {
        
        [aryStr addObject:number.stringValue];
    }
    
    _baseAry = [NSArray arrayWithArray:aryStr];
}

- (void)loadBarLayer
{
    NSArray *sumAry = [[aryAddup(_dataArys) reverseObjectEnumerator] allObjects];
    NSArray *colors = [[_colorAry reverseObjectEnumerator] allObjects];
    
    NSArray *pointArys = [_lineLayer draw_updateSpiders:^(GraphSpider *make) {
        
        for (NSInteger i = 0; i < sumAry.count; i++) {
            
            NSArray *dataAry = sumAry[i];
            UIColor *color = colors[i];
            UIColor *fillColor = [color colorWithAlphaComponent:0.5];
            
            make.drawLine.drawAry(dataAry).color(color).witdth(1);
            make.drawLine.drawAry(dataAry).rounder(0).fillColor(fillColor);
        }
    }];
    
    PaintBrush *drawer = [[PaintBrush alloc] init];
    drawer.width = 1;
    drawer.fillClr = [UIColor whiteColor];
    
    //NSLog(@"%@", pointArys);
}

- (void)stockBackGroundLayer
{
    CGFloat interval_x = _lineLayer.width / _titleAry.count;
    CGFloat interval_y = _lineLayer.height / (_baseAry.count - 1);
    
    PaintBrush *drawer = [[PaintBrush alloc] init];
    drawer.stockClr = __RGB_GRAY;
    drawer.width = 0.6;
    drawer.font = [UIFont systemFontOfSize:8];
    
    for (NSInteger i = 0; i < _titleAry.count; i++) {
        
        CGFloat offset = (i + 1) * interval_x;
        CGPoint lineStart = OFFSET_X(_lineLayer.topLeft, offset);
        CGPoint lineEnd = OFFSET_X(_lineLayer.lowerLeft, offset);
        CGPoint diverEnd = OFFSET_Y(lineEnd, 3);
        CGPoint textPt = CGPointMake(_lineLayer.left + interval_x * i + interval_x / 2, diverEnd.y + 1);
        
        [drawer setStockClr:__RGB_GRAY];
        [drawer drawStart:lineStart end:lineEnd];
        [drawer setStockClr:[UIColor blackColor]];
        [drawer drawStart:lineEnd end:diverEnd];
        [drawer drawTxt:_titleAry[i] atBottom:textPt];
    }
    
    NSArray *base = [[_baseAry reverseObjectEnumerator] allObjects];
    
    for (NSInteger i = 0; i < _baseAry.count; i++) {
        
        CGFloat offset = i * interval_y;
        CGPoint lineStart = OFFSET_Y(_lineLayer.topLeft, offset);
        CGPoint lineEnd = OFFSET_Y(_lineLayer.topRight, offset);
        CGPoint diverEnd = OFFSET_X(lineStart, -3);
        CGPoint textPt = CGPointMake(_lineLayer.left - 4, diverEnd.y);
        
        [drawer setStockClr:__RGB_GRAY];
        [drawer drawStart:lineStart end:lineEnd];
        [drawer setStockClr:[UIColor blackColor]];
        [drawer drawStart:lineStart end:diverEnd];
        [drawer drawTxt:base[i] atLeft:textPt];
    }
    
    [drawer drawStart:_lineLayer.lowerLeft end:_lineLayer.lowerRight];
    [drawer drawStart:_lineLayer.topLeft end:_lineLayer.lowerLeft];
    [drawer drawStart:_lineLayer.lowerLeft end:OFFSET_Y(_lineLayer.lowerLeft, 3)];
    [_backgroundLayer drawWithBrush:drawer];
}

- (void)addAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 1;
    
    [_lineLayer addAnimationForSubLayers:animation];
}

- (void)stockChart
{
    [self loadViewData];
    
    [self loadBarLayer];
    [self stockBackGroundLayer];
}

@end
