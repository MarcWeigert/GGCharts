//
//  LineBarView.m
//  HSCharts
//
//  Created by _ | Durex on 16/12/11.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "LineBarView.h"
#import "SawGraph.h"
#import "Colors.h"

@interface LineBarView ()

@property (nonatomic) CALayer *dataLayer;    ///< 柱状图层

@property (nonatomic) VirginLayer *backLayer;   ///< 网格层

@property (nonatomic) NSArray <NSNumber *> *baseAry;    ///< 纵坐标关键价格点

@end

@implementation LineBarView

#pragma mark - 父类方法

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _dataLayer = [[CALayer alloc] init];
        _backLayer = [[VirginLayer alloc] init];
        
        [self setFrame:frame];
        [_backLayer addSublayer:_dataLayer];
        [self.layer addSublayer:_backLayer];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _backLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _dataLayer.frame = CGRectMake(30, 20, _backLayer.width - 40, _backLayer.height - 40);
}

#pragma mark - 图表绘制

/** 初始化数据 */
- (void)loadViewData
{
    float max = getAryMax(@[_lineAry, _barAry]);
    float min = getAryMin(@[_lineAry, _barAry]);
    
    // 通过数组中最大值, 最小值生成价格分割数组
    _baseAry = makeBaseAry(max, min);
}

/** 设置柱状图层 */
- (void)stockBarLayer
{
    // 设置层内最高最低价
    _dataLayer.min = [[_baseAry firstObject] floatValue];
    _dataLayer.max = [[_baseAry lastObject] floatValue];
    
    [_dataLayer draw_updateSpiders:^(GraphSpider *make) {
        
        [_barAry enumerateObjectsUsingBlock:^(NSNumber *data, NSUInteger idx, BOOL * stop) {
            
            make.drawBar.drawAry(_barAry).color(_barColor).witdth(10);
        }];
        
        [_lineAry enumerateObjectsUsingBlock:^(NSNumber *data, NSUInteger idx, BOOL * stop) {
            
            make.drawLine.drawAry(_lineAry).row(1).color(_lineColor).witdth(1);
        }];
    }];
}

/** 设置背景网格层 */
- (void)stockBackGroundLayer
{
    // 横纵线偏移量
    CGFloat x = _dataLayer.width / _titleAry.count;
    CGFloat y = _dataLayer.height / (_baseAry.count - 1);
    
    // 设置绘制字体, 颜色, 文字内容
    UIFont *font = [UIFont systemFontOfSize:8];
    UIColor *txtColor = [UIColor blackColor];
    NSArray *base = [[_baseAry reverseObjectEnumerator] allObjects];
    
    [_backLayer draw_updateFrame:_dataLayer.frame lizard:^(GraphLizard *make) {
        
        CGPoint startx = CGPointMake(-3, 0);
        CGPoint endy = CGPointMake(0, _dataLayer.height + 3);
        
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
            make.makeText.point(CGPointMake(0, _dataLayer.height)).offset(offset).type(T_BOTTOM);
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
            make.makeLine.line(startx, CGPointMake(_dataLayer.width, 0)).y(idx * y);
            make.makeLine.color(__RGB_GRAY).width(0.6);
            make.makeLine.draw();
            
            // 文字
            make.makeText.text([base[idx] stringValue]).font(font).color(txtColor);
            make.makeText.point(CGPointMake(0, 0)).offset(offset).type(T_LEFT);
            make.makeText.draw();
        }];
    }];
}

/** 绘制视图 */
- (void)stockChart
{
    [self loadViewData];
    
    [self stockBarLayer];
    [self stockBackGroundLayer];
}

/** 增加动画 */
- (void)addAnimation:(NSTimeInterval)duration
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = duration;
    
    [_dataLayer addAnimationForSubLayers:animation];
}
@end
