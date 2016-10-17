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

@property (nonatomic) CALayer *lineLayer;       ///< 折线层

@property (nonatomic) CALayer *fillLayer;       ///< 折线填充层

@property (nonatomic) CALayer *roundLayer;      ///< 加个点层

@property (nonatomic) VirginLayer *backLayer;   ///< 网格背景层

@property (nonatomic) NSArray <NSNumber *> *baseAry;    ///< y轴价格分割

@property (nonatomic) NSArray <NSArray<NSValue *> *> *pointArys;    ///< 二维数组, 存放折线点坐标

@end

@implementation CumSumLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _lineLayer = [[CALayer alloc] init];
        _fillLayer = [[CALayer alloc] init];
        _roundLayer = [[CALayer alloc] init];
        _backLayer = [[VirginLayer alloc] init];
        
        [self setFrame:frame];
        [_backLayer addSublayer:_fillLayer];
        [_backLayer addSublayer:_lineLayer];
        [_backLayer addSublayer:_roundLayer];
        [self.layer addSublayer:_backLayer];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _backLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _lineLayer.frame = CGRectMake(30, 20, _backLayer.width - 40, _backLayer.height - 40);
    _roundLayer.frame = _lineLayer.frame;
    _fillLayer.frame = _lineLayer.frame;
}

- (void)loadViewData
{
    NSArray *sumAry = aryAddup(_dataArys);
    
    float max = getAryMax(sumAry);
    float min = getAryMin(sumAry);
    
    _baseAry = makeBaseAry(max, min);
}

/** 循环遍历数据、颜色数组 */
- (void(^)(void (^loop) (NSArray *data, UIColor *color)))repeat
{
    NSArray *sumAry = [[aryAddup(_dataArys) reverseObjectEnumerator] allObjects];
    NSArray *colors = [[_colorAry reverseObjectEnumerator] allObjects];
    
    return ^(void (^loop) (NSArray *data, UIColor *color)) {
    
        for (NSInteger i = 0; i < sumAry.count; i++) {
            
            NSArray *dataAry = sumAry[i];
            UIColor *color = colors[i];
            
            loop(dataAry, color);
        }
    };
}

- (void)drawLineLayer
{
    _lineLayer.max = [[_baseAry lastObject] floatValue];
    _lineLayer.min = [[_baseAry firstObject] floatValue];
    
    _pointArys = [_lineLayer draw_updateSpiders:^(GraphSpider *make) {
        
        self.repeat(^(NSArray *data, UIColor *color){
            
            make.drawLine.drawAry(data).color(color).witdth(1);
        });
    }];
}

- (void)drawFillLayer
{
    _fillLayer.max = [[_baseAry lastObject] floatValue];
    _fillLayer.min = [[_baseAry firstObject] floatValue];
    
    [_fillLayer draw_updateSpiders:^(GraphSpider *make) {
        
        self.repeat(^(NSArray *data, UIColor *color){
            
            UIColor *fillColor = [color colorWithAlphaComponent:0.5];
            
            make.drawLine.drawAry(data).rounder(0).fillColor(fillColor);
        });
    }];
}

- (void)drawRoundLayer
{
    NSArray *colors = [[_colorAry reverseObjectEnumerator] allObjects];
    
    [_roundLayer draw_updateSpiders:^(GraphSpider *make) {
        
        [_pointArys enumerateObjectsUsingBlock:^(NSArray<NSValue *> * obj, NSUInteger idx, BOOL * stop) {
            
            UIColor *color = colors[idx];
            UIColor *filColor = [UIColor whiteColor];
            
            [obj enumerateObjectsUsingBlock:^(NSValue * pt, NSUInteger i, BOOL * stop) {
                
                make.drawRound.centerPoint(pt.CGPointValue).fillColor(filColor).edgeColor(color).radius(2).edgeWidth(1);
            }];
        }];
    }];
}

/** 绘制背景 */
- (void)stockBackGroundLayer
{
    // 横纵线偏移量
    CGFloat x = _lineLayer.width / (_titleAry.count - 1);
    CGFloat y = _lineLayer.height / (_baseAry.count - 1);
    
    UIFont *font = [UIFont systemFontOfSize:8];
    UIColor *txtColor = [UIColor blackColor];
    NSArray *base = [[_baseAry reverseObjectEnumerator] allObjects];
    
    [_backLayer draw_updateFrame:_lineLayer.frame lizard:^(GraphLizard *make) {
        
        CGPoint startx = OFFSET_X(_backLayer.gul, -3);
        CGPoint endy = OFFSET_Y(_backLayer.gbl, 3);
        
        // 网格纵线以及标志文字
        [_titleAry enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * stop) {
           
            CGPoint offset = CGPointMake(idx * x, 4);
            
            make.makeLine.line(_backLayer.gul, endy).x(idx * x);
            make.makeLine.color(__RGB_GRAY).width(0.6);
            make.makeLine.draw();
            
            make.makeText.text(_titleAry[idx]).font(font).color(txtColor);
            make.makeText.point(_backLayer.gbl).offset(offset).type(T_BOTTOM);
            make.makeText.draw();
        }];
        
        // 网格横线以及标志文字
        [base enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * stop) {
        
            CGPoint offset = CGPointMake(-4, idx * y);
            
            make.makeLine.line(startx, _backLayer.gur).y(idx * y);
            make.makeLine.color(__RGB_GRAY).width(0.6);
            make.makeLine.draw();
            
            make.makeText.text([base[idx] stringValue]).font(font).color(txtColor);
            make.makeText.point(_backLayer.gul).offset(offset).type(T_LEFT);
            make.makeText.draw();
        }];
    }];
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
    
    [self drawLineLayer];
    [self drawFillLayer];
    [self drawRoundLayer];
    
    [self stockBackGroundLayer];
}

@end
