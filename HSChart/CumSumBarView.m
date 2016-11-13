//
//  CumSumBarView.m
//  HSCharts
//
//  Created by 黄舜 on 16/6/24.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "CumSumBarView.h"
#import "SawGraph.h"
#import "Colors.h"

@interface CumSumBarView ()

@property (nonatomic) CALayer *barLayer;

@property (nonatomic) VirginLayer *backLayer;

@property (nonatomic) NSArray <NSNumber *> *baseAry;

@end

@implementation CumSumBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _barLayer = [[CALayer alloc] init];
        _backLayer = [[VirginLayer alloc] init];
        
        [self setFrame:frame];
        [_backLayer addSublayer:_barLayer];
        [self.layer addSublayer:_backLayer];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _backLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _barLayer.frame = CGRectMake(30, 20, _backLayer.width - 40, _backLayer.height - 40);
}

- (void)loadViewData
{
    NSArray *sumAry = aryAddup(_dataArys);
    
    float max = getAryMax(sumAry);
    float min = getAryMin(sumAry);
    
    _baseAry = makeBaseAry(max, min);
}

- (void)loadBarLayer
{
    NSArray <NSArray <NSNumber *>*> *sumAry = [[aryAddup(_dataArys) reverseObjectEnumerator] allObjects];
    
    _barLayer.max = [[_baseAry lastObject] floatValue];
    _barLayer.min = [[_baseAry firstObject] floatValue];
    
    [_barLayer draw_updateSpiders:^(GraphSpider *make) {
        
        [sumAry enumerateObjectsUsingBlock:^(NSArray<NSNumber *> * dataAry, NSUInteger idx, BOOL * stop) {
            
            UIColor *color = _colorAry[idx];
            
            make.drawBar.drawAry(dataAry).color(color).witdth(35);
        }];
    }];
}

- (void)stockBackGroundLayer
{
    // 横纵线偏移量
    CGFloat x = _barLayer.width / _titleAry.count;
    CGFloat y = _barLayer.height / (_baseAry.count - 1);
    
    UIFont *font = [UIFont systemFontOfSize:8];
    UIColor *txtColor = [UIColor blackColor];
    NSArray *base = [[_baseAry reverseObjectEnumerator] allObjects];
    
    [_backLayer draw_updateFrame:_barLayer.frame lizard:^(GraphLizard *make) {
        
        CGPoint startx = CGPointMake(-3, 0);
        CGPoint endy = CGPointMake(0, _barLayer.height + 3);
        
        // 网格纵线以及标志文字
        [_titleAry enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * stop) {
            
            CGPoint offset = CGPointMake(idx * x + x / 2, 4);
            
            make.makeLine.line(CGPointZero, endy).x(idx * x);
            make.makeLine.color(__RGB_GRAY).width(0.6);
            make.makeLine.draw();
            
            make.makeText.text(_titleAry[idx]).font(font).color(txtColor);
            make.makeText.point(CGPointMake(0, _barLayer.height)).offset(offset).type(T_BOTTOM);
            make.makeText.draw();
            
            if (idx == _titleAry.count - 1) {
                idx += 1;
                make.makeLine.line(CGPointZero, endy).x(idx * x);
                make.makeLine.color(__RGB_GRAY).width(0.6);
                make.makeLine.draw();
            }
        }];
        
        // 网格横线以及标志文字
        [base enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * stop) {
            
            CGPoint offset = CGPointMake(-4, idx * y);
            
            make.makeLine.line(startx, CGPointMake(_barLayer.width, 0)).y(idx * y);
            make.makeLine.color(__RGB_GRAY).width(0.6);
            make.makeLine.draw();
            
            make.makeText.text([base[idx] stringValue]).font(font).color(txtColor);
            make.makeText.point(CGPointZero).offset(offset).type(T_LEFT);
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
    animation.duration = 3;
    
    [_barLayer addAnimationForSubLayers:animation];
}

- (void)stockChart
{
    [self loadViewData];
    
    [self loadBarLayer];
    [self stockBackGroundLayer];
}

@end
