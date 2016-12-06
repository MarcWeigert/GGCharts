//
//  CrossLineView.m
//  HSCharts
//
//  Created by 黄舜 on 16/6/27.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "CrossLineView.h"
#import "SawGraph.h"
#import "Colors.h"

@interface CrossLineView ()

@property (nonatomic) CALayer *topLayer;

@property (nonatomic) CALayer *bottomLayer;

@property (nonatomic) VirginLayer *backLayer;

@property (nonatomic) NSArray <NSNumber *> *topBaseAry;

@property (nonatomic) NSArray <NSNumber *> *bottomBaseAry;

@end

@implementation CrossLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _topLayer = [[CALayer alloc] init];
        _bottomLayer = [[CALayer alloc] init];
        _backLayer = [[VirginLayer alloc] init];
        
        [self setFrame:frame];
        [_backLayer addSublayer:_bottomLayer];
        [_backLayer addSublayer:_topLayer];
        [self.layer addSublayer:_backLayer];
        
        //_backLayer.backgroundColor = [UIColor blackColor].CGColor;
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGFloat interval = frame.size.height / 10;
    CGFloat height = frame.size.height * 9 / 10 / 2;
    
    _backLayer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    _bottomLayer.frame = CGRectMake(30, 10, _backLayer.width - 60, height - 10);
    _topLayer.frame = CGRectMake(30, interval + height - 10, _backLayer.width - 60, height - 10);
}

- (void)loadViewData
{
    float top_max = getMax(_topAry);
    float top_min = getMin(_topAry);
    float bottom_max = getMax(_bottomAry);
    float bottom_min = getMax(_bottomAry);
    
    top_min = top_min > 0 ? 0 : top_min;
    bottom_min = bottom_min > 0 ? 0 : bottom_min;
    
    _topBaseAry = makeBaseAry(top_max, top_min);
    _bottomBaseAry = makeBaseAry(bottom_max, bottom_min);
}

- (void)loadBackGroundLayer
{
    UIColor *color = [UIColor blackColor];
    UIFont *font = [UIFont systemFontOfSize:_topLayer.frame.size.width / self.bounds.size.width * 9];
    NSArray *bottomAry = [[_bottomBaseAry reverseObjectEnumerator] allObjects];
    CGFloat ly = _bottomLayer.height / (_bottomBaseAry.count - 1);
    CGFloat ry = _bottomLayer.height / (_topBaseAry.count - 1);
    CGFloat x = _bottomLayer.width / _titleAry.count;
    
    [_backLayer draw_updateFrame:CGRectMake(0, 0, _topLayer.width, _topLayer.height) lizard:^(GraphLizard *make) {
        
        make.makeLine.width(0.6).color(color);
        make.makeLine.line(_topLayer.topLeft, _topLayer.lowerLeft).draw();
        make.makeLine.line(_bottomLayer.topLeft, _bottomLayer.lowerLeft).draw();
        make.makeLine.line(_topLayer.topLeft, _topLayer.topRight).draw();
        make.makeLine.line(_bottomLayer.lowerLeft, _bottomLayer.lowerRight).draw();
        
        [bottomAry enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
            
            make.makeLine.color(color);
            make.makeLine.line(_bottomLayer.topLeft, OFFSET_X(_bottomLayer.topLeft, -3)).y(ly * idx);
            make.makeLine.draw();
            
            make.makeText.text([obj stringValue]).font(font).color(color);
            make.makeText.point(OFFSET_X(_bottomLayer.topLeft, -4)).y(ly * idx).type(T_LEFT);
            make.makeText.draw();
            
            make.makeLine.color(__RGB_GRAY);
            make.makeLine.line(_bottomLayer.topLeft, _bottomLayer.topRight).y(ly * idx);
            make.makeLine.draw();
        }];
        
        [_topBaseAry enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
            
            make.makeLine.line(_topLayer.topLeft, OFFSET_X(_topLayer.topLeft, -3)).y(ry * idx);
            make.makeLine.draw();
            
            make.makeText.text([obj stringValue]).font(font).color(color);
            make.makeText.point(OFFSET_X(_topLayer.topLeft, -4)).y(ry * idx).type(T_LEFT);
            make.makeText.draw();
            
            make.makeLine.line(_topLayer.topLeft, _topLayer.topRight).y(ry * idx);
            make.makeLine.draw();
        }];
        
//        [_titleAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
//            
//            make.makeLine.line(_topLayer.lowerLeft, OFFSET_Y(_topLayer.lowerLeft, 3)).x(x * idx);
//            make.makeLine.draw();
//            
//            make.makeText.text(obj).font(font).color(color);
//            make.makeText.point(OFFSET_Y(_topLayer.lowerLeft, 4)).x(x * idx + x / 2).type(T_BOTTOM);
//            make.makeText.draw();
//            
//            if (idx == _titleAry.count - 1) {
//                idx += 1;
//                make.makeLine.line(_topLayer.lowerLeft, OFFSET_Y(_topLayer.lowerLeft, 3)).x(x * idx);
//                make.makeLine.draw();
//            }
//        }];
    }];
}

- (void)loadLineLayer
{
    _topLayer.max = [_topBaseAry.lastObject floatValue];
    _topLayer.min = [_topBaseAry.firstObject floatValue];
    _bottomLayer.max = [_bottomBaseAry.lastObject floatValue];
    _bottomLayer.min = [_bottomBaseAry.firstObject floatValue];
    
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
