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

@property (nonatomic) CALayer *barLayer;    ///< 柱状图层

@property (nonatomic) VirginLayer *backLayer;   ///< 网格层

@property (nonatomic) NSArray <NSNumber *> *baseAry;    ///< 纵坐标关键价格点

@end

@implementation RankBarView

#pragma mark - 父类方法

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

#pragma mark - 图表绘制

/** 初始化数据 */
- (void)loadViewData
{
    float max = getAryMax(_dataArys);
    float min = getAryMin(_dataArys);
    
    // 通过数组中最大值, 最小值生成价格分割数组
    _baseAry = makeBaseAry(max, min);
}

/** 设置背景网格层 */
- (void)stockBackGroundLayer
{
    // 横纵线偏移量
    CGFloat x = _barLayer.width / _titleAry.count;
    CGFloat y = _barLayer.height / (_baseAry.count - 1);
    
    // 设置绘制字体, 颜色, 文字内容
    UIFont *font = [UIFont systemFontOfSize:8];
    UIColor *txtColor = [UIColor blackColor];
    NSArray *base = [[_baseAry reverseObjectEnumerator] allObjects];
    
    [_backLayer draw_updateFrame:_barLayer.frame lizard:^(GraphLizard *make) {
        
        CGPoint startx = CGPointMake(-3, 0);
        CGPoint endy = CGPointMake(0, _barLayer.height + 3);
        
        // 网格纵线以及标志文字
        [_titleAry enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * stop) {
            
            // 文字偏移量
            CGPoint offset = CGPointMake(idx * x + x / 2, 4);
            
            // 横线
            make.makeLine.line(CGPointMake(0, 0), endy).x(idx * x);
            make.makeLine.color(__RGB_GRAY).width(0.6);
            make.makeLine.draw();
            
            // 文字
            make.makeText.text(_titleAry[idx]).font(font).color(txtColor);
            make.makeText.point(CGPointMake(0, _barLayer.height)).offset(offset).type(T_BOTTOM);
            make.makeText.draw();
            
            if (idx == _titleAry.count - 1) {   // 最后一根需要多绘制一条
                idx += 1;
                make.makeLine.line(CGPointMake(0, 0), endy).x(idx * x);
                make.makeLine.color(__RGB_GRAY).width(0.6);
                make.makeLine.draw();
            }
        }];
        
        // 网格横线以及标志文字
        [base enumerateObjectsUsingBlock:^(NSString *text, NSUInteger idx, BOOL * stop) {
            
            // 文字偏移量
            CGPoint offset = CGPointMake(-4, idx * y);
            
            // 横线
            make.makeLine.line(startx, CGPointMake(_barLayer.width, 0)).y(idx * y);
            make.makeLine.color(__RGB_GRAY).width(0.6);
            make.makeLine.draw();
            
            // 文字
            make.makeText.text([base[idx] stringValue]).font(font).color(txtColor);
            make.makeText.point(CGPointMake(0, 0)).offset(offset).type(T_LEFT);
            make.makeText.draw();
        }];
    }];
}

/** 设置柱状图层 */
- (void)stockBarLayer
{
    // 设置层内最高最低价
    _barLayer.min = [[_baseAry firstObject] floatValue];
    _barLayer.max = [[_baseAry lastObject] floatValue];
    
    [_barLayer draw_updateSpiders:^(GraphSpider *make) {
        
        [_dataArys enumerateObjectsUsingBlock:^(NSArray *dataAry, NSUInteger idx, BOOL * stop) {
            
            UIColor *color = _colorAry[idx];
            
            // 绘制柱状图
            make.drawBar
                .drawAry(dataAry)
                .color(color)
                .row(_dataArys.count)
                .index(idx)
                .witdth(8);
        }];
    }];
}

/** 增加动画 */
- (void)addAnimation:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = duration;
    
    [_barLayer addAnimationForSubLayers:animation];
}

/** 绘制 */
- (void)stockChart
{
    // 数据
    [self loadViewData];
    
    // 视图
    [self stockBarLayer];
    [self stockBackGroundLayer];
}

@end
