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

@interface HollowFanView ()

@property (nonatomic) CALayer *contentLayer;

@end

@implementation HollowFanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _contentLayer = [[CALayer alloc] init];
        
        [self setFrame:frame];
        
        [self.layer addSublayer:_contentLayer];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _contentLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)makeContentLayer
{
    CGFloat radius = self.frame.size.width > self.frame.size.height ? self.frame.size.width / 2 : self.frame.size.height / 2;
    CGFloat width = radius / 4;
    radius -= width;
    
    [_contentLayer draw_updateSpiders:^(GraphSpider *make) {
        
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
