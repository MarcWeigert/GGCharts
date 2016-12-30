//
//  HollowFanView.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/13.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "HollowFanView.h"
#import "SawGraph.h"
#import "Colors.h"
#import "QueryView.h"

@interface HollowFanView ()

@property (nonatomic) CALayer *contentLayer;

@property (nonatomic) VirginLayer *backLayer;

@property (nonatomic) QueryView *qyView;

@property (nonatomic) CGFloat radius;

@property (nonatomic) NSArray<NSArray<NSNumber *> *> *angleArys;

@end

@implementation HollowFanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _contentLayer = [[CALayer alloc] init];
        _backLayer = [[VirginLayer alloc] init];
        
        [self setFrame:frame];
        [self.layer addSublayer:_backLayer];
        [_backLayer addSublayer:_contentLayer];
        
        _qyView = [[QueryView alloc] initWithFrame:CGRectZero];
        _qyView.font = [UIFont systemFontOfSize:12];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _contentLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _backLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _radius = self.frame.size.width > self.frame.size.height ? self.frame.size.width / 2 : self.frame.size.height / 2 - 25;
    _qyView.font = [UIFont systemFontOfSize:_radius / 120 * 12];
}

- (void)updateCenter:(NSInteger)index
{
    UIColor *color = _colorAry[index];
    NSString *text = _titleAry[index];
    UIFont *font = [UIFont boldSystemFontOfSize:_radius / 120 * 25];
    
    [_backLayer draw_updateFrame:_contentLayer.frame lizard:^(GraphLizard *make) {
        
        make.makeText
            .font(font)
            .text(text)
            .color(color)
            .point(CGPointMake(_contentLayer.width / 2, _contentLayer.height / 2));
        
        make.makeText.draw();
    }];
}

- (void)updateQueryView:(NSInteger)index point:(CGPoint)point
{
    NSArray *angle = _angleArys[index];
    CGFloat start = [[angle firstObject] floatValue];
    CGFloat end = [[angle lastObject] floatValue];
    CGFloat base = (end - start) / 360;
    
    [_qyView setTitle:@"空心饼图"
           classTitle:_titleAry[index]
            numerical:_dataAry[index]
                 base:base];
    
    [UIView animateWithDuration:0.2 animations:^{
        
        _qyView.frame = CGRectMake(point.x, point.y, _qyView.frame.size.width, _qyView.frame.size.height);
    }];
}

- (void)updateContentLayer:(NSInteger)index
{
    CGFloat width = _radius / 3.5;
    CGFloat radius = _radius - width;
    
    [_contentLayer draw_updateSpiders:^(GraphSpider *make) {
        
        [_colorAry enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger i, BOOL * stop) {
            
            if (i == index) {
            
                make.drawRound.drawAry(_dataAry, i).edgeWidth(width + 8).radius(radius).edgeColor(color);
            }
            else {
            
                make.drawRound.drawAry(_dataAry, i).edgeWidth(width).radius(radius).edgeColor(color);
            }
        }];
    }];
}

/** 手势交互 */
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    [_angleArys enumerateObjectsUsingBlock:^(NSArray<NSNumber *> * obj, NSUInteger idx, BOOL * stop) {
        
        CGFloat start = [[obj firstObject] floatValue];
        CGFloat end = [[obj lastObject] floatValue];
        
        if ([self effectiveArea:point startAngle:start endAngle:end]) {
            
            [self updateCenter:idx];
            [self updateContentLayer:idx];
            [self updateQueryView:idx point:point];
            [self addSubview:_qyView];
        }
    }];
}

/** 扇形详细更新数据区域 */
- (BOOL)effectiveArea:(CGPoint)point startAngle:(CGFloat)start endAngle:(CGFloat)end
{
    CGFloat width = _radius / 3.5;
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    return isInRingArc(center, point, _radius, width,  start, end, NO);
}

- (void)makeContentLayer
{
    CGFloat width = _radius / 3.5;
    CGFloat radius = _radius - width;
    
    _angleArys = [_contentLayer draw_updateSpiders:^(GraphSpider *make) {
        
        [_colorAry enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger i, BOOL * stop) {
                        
            make.drawRound.drawAry(_dataAry, i).edgeWidth(width).radius(radius).edgeColor(color);
        }];
    }];
}

- (void)stockChart
{
    [self makeContentLayer];
}

- (void)addAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    animation.fromValue = @0;
    animation.toValue = @1;
    animation.duration = 1;
    
    [_contentLayer addAnimationForSubLayers:animation];
}

@end
