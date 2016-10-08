//
//  RankBarView.m
//  HSCharts
//
//  Created by 黄舜 on 16/6/23.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "RankBarView.h"
#import "SawGraph.h"
#import "Colors.h"

@interface RankBarView ()

@property (nonatomic) CALayer *barLayer;

@property (nonatomic) BoardLayer *backgroundLayer;

@property (nonatomic) NSArray <NSString *> *baseAry;

@end

@implementation RankBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _barLayer = [[CALayer alloc] init];
        _backgroundLayer = [[BoardLayer alloc] init];
        
        [self setFrame:frame];
        [_backgroundLayer addSublayer:_barLayer];
        [self.layer addSublayer:_backgroundLayer];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _backgroundLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _barLayer.frame = CGRectMake(30, 20, _backgroundLayer.width - 40, _backgroundLayer.height - 40);
}

- (void)loadViewData
{
    float max = getAryMax(_dataArys);
    float min = getAryMin(_dataArys);
    
    NSArray *baseAry = makeBaseAry(max, min);
    NSMutableArray *aryStr = [NSMutableArray array];
    
    _barLayer.max = [[baseAry lastObject] floatValue];
    _barLayer.min = [[baseAry firstObject] floatValue];
    
    for (NSNumber *number in baseAry) {
        
        [aryStr addObject:number.stringValue];
    }
    
    _baseAry = [NSArray arrayWithArray:aryStr];
}

- (void)stockBackGroundLayer
{
    CGFloat interval_x = _barLayer.width / _titleAry.count;
    CGFloat interval_y = _barLayer.height / (_baseAry.count - 1);
    
    PaintBrush *drawer = [[PaintBrush alloc] init];
    drawer.stockClr = __RGB_GRAY;
    drawer.width = 0.6;
    drawer.font = [UIFont systemFontOfSize:8];
    
    for (NSInteger i = 0; i < _titleAry.count; i++) {
        
        CGFloat offset = (i + 1) * interval_x;
        CGPoint lineStart = OFFSET_X(_barLayer.topLeft, offset);
        CGPoint lineEnd = OFFSET_X(_barLayer.lowerLeft, offset);
        CGPoint diverEnd = OFFSET_Y(lineEnd, 3);
        CGPoint textPt = CGPointMake(_barLayer.left + interval_x * i + interval_x / 2, diverEnd.y + 1);
        
        [drawer setStockClr:__RGB_GRAY];
        [drawer drawStart:lineStart end:lineEnd];
        [drawer setStockClr:[UIColor blackColor]];
        [drawer drawStart:lineEnd end:diverEnd];
        [drawer drawTxt:_titleAry[i] atBottom:textPt];
    }
    
    NSArray *base = [[_baseAry reverseObjectEnumerator] allObjects];
    
    for (NSInteger i = 0; i < _baseAry.count; i++) {
        
        CGFloat offset = i * interval_y;
        CGPoint lineStart = OFFSET_Y(_barLayer.topLeft, offset);
        CGPoint lineEnd = OFFSET_Y(_barLayer.topRight, offset);
        CGPoint diverEnd = OFFSET_X(lineStart, -3);
        CGPoint textPt = CGPointMake(_barLayer.left - 4, diverEnd.y);
        
        [drawer setStockClr:__RGB_GRAY];
        [drawer drawStart:lineStart end:lineEnd];
        [drawer setStockClr:[UIColor blackColor]];
        [drawer drawStart:lineStart end:diverEnd];
        [drawer drawTxt:base[i] atLeft:textPt];
    }
    
    [drawer drawStart:_barLayer.lowerLeft end:_barLayer.lowerRight];
    [drawer drawStart:_barLayer.topLeft end:_barLayer.lowerLeft];
    [drawer drawStart:_barLayer.lowerLeft end:OFFSET_Y(_barLayer.lowerLeft, 3)];
    [_backgroundLayer drawWithBrush:drawer];
}

- (void)stockBarLayer
{
    [_barLayer draw_updateSpiders:^(GraphSpider *make) {
        
        for (NSInteger i = 0; i < _dataArys.count; i++) {
            
            NSArray *dataAry = _dataArys[i];
            UIColor *color = _colorAry[i];
            
            make.drawBar.drawAry(dataAry).color(color).row(_dataArys.count).index(i).witdth(8);
        }
    }];
}

- (void)addAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 3;
    
    [_barLayer addAnimationForSubLayers:animation];
}

- (void)stockChart
{
    [self loadViewData];
    
    [self stockBarLayer];
    [self stockBackGroundLayer];
}

@end
