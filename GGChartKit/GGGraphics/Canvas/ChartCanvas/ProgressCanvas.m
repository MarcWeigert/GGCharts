//
//  ProgressCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 17/10/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "ProgressCanvas.h"

@interface ProgressCanvas ()

/**
 * 中心圆点
 */
@property (nonatomic, strong) CALayer * pointLayer;

/**
 * 中间文字渲染器
 */
@property (nonatomic, strong) GGNumberRenderer * numbeRrenderer;

/**
 * 进度条
 */
@property (nonatomic, weak) GGShapeCanvas * progressCanvas;

/**
 * CADisplayLink
 */
@property (nonatomic, strong) Animator * animator;

@end

@implementation ProgressCanvas

- (void)drawChart
{
    [super drawChart];
    
    CGPoint center = CGPointMake(self.gg_width / 2, self.gg_height / 2);
    
    CGFloat start = [_progressAbstract arcRange].max;
    CGFloat end = [_progressAbstract arcRange].min;
    CGFloat radius = [_progressAbstract progressRadius];
    
    CGMutablePathRef ref = CGPathCreateMutable();
    GGPathAddArc(ref, center, radius, start, end);
    
    GGShapeCanvas * shapeLayer = [self getGGShapeCanvasEqualFrame];
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = [_progressAbstract lineWidth];
    shapeLayer.path = ref;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = [_progressAbstract progressBackColor].CGColor;
    CGPathRelease(ref);
    
    CGFloat progressEnd = start + (end - start + M_PI * 2) * ([_progressAbstract value] / [_progressAbstract maxValue]);
    CGMutablePathRef progersRef = CGPathCreateMutable();
    GGPathAddArc(progersRef, center, radius, start, progressEnd);
    
    _progressCanvas = [self getGGShapeCanvasEqualFrame];
    _progressCanvas.lineCap = kCALineCapRound;
    _progressCanvas.lineWidth = [_progressAbstract lineWidth];
    _progressCanvas.path = progersRef;
    _progressCanvas.fillColor = [UIColor clearColor].CGColor;
    _progressCanvas.strokeColor = [UIColor whiteColor].CGColor;
    CGPathRelease(progersRef);
    
    if ([_progressAbstract progressGradientColor].count > 0) {
        
        CAGradientLayer * gradientLayer = [self getCAGradientEqualFrame];
        gradientLayer.mask = _progressCanvas;
        CGFloat startRatio = center.x - radius;
        CGFloat endRatio = center.x + radius;
        gradientLayer.colors = [[_progressAbstract progressGradientColor] getCGColorsArray];
        gradientLayer.locations = [_progressAbstract gradientLocations];
        
        if ([_progressAbstract gradientCurve] == GradientX) {
            
            gradientLayer.startPoint = CGPointMake(startRatio / self.gg_width, .5f);
            gradientLayer.endPoint = CGPointMake(endRatio / self.gg_width, .5f);
        }
        else {
        
            gradientLayer.startPoint = CGPointMake(.5f, startRatio / self.gg_height);
            gradientLayer.endPoint = CGPointMake(.5f, endRatio / self.gg_height);
        }
    }
    
    self.pointLayer.frame = CGRectZero;
    self.pointLayer.gg_size = CGSizeMake([_progressAbstract pointRadius], [_progressAbstract pointRadius]);
    self.pointLayer.cornerRadius = [_progressAbstract pointRadius] / 2;
    self.pointLayer.backgroundColor = [_progressAbstract pointColor].CGColor;
    
    CGFloat x = center.x + radius * cos(progressEnd);
    CGFloat y = center.y + radius * sin(progressEnd);
    self.pointLayer.position = CGPointMake(x, y);
    
    self.numbeRrenderer.toPoint = center;
    self.numbeRrenderer.fromPoint = center;
    self.numbeRrenderer.fromNumber = 0;
    self.numbeRrenderer.toNumber = [_progressAbstract value];
    self.numbeRrenderer.font = [[_progressAbstract centerLable] lableFont];
    self.numbeRrenderer.offSetRatio = [[_progressAbstract centerLable] stringRatio];
    self.numbeRrenderer.offSet = [[_progressAbstract centerLable] stringOffSet];
    self.numbeRrenderer.format = [[_progressAbstract centerLable] stringFormat];
    self.numbeRrenderer.color = [[_progressAbstract centerLable] lableColor];
    self.numbeRrenderer.attrbuteStringValueBlock = [[_progressAbstract centerLable] attrbuteStringValueBlock];
    [self.numbeRrenderer drawAtToNumberAndPoint];
    [self setNeedsDisplay];
}

/**
 * 启动动画
 */
- (void)startAnimationWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation * strockAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strockAnimation.duration = duration;
    strockAnimation.fromValue = @0;
    strockAnimation.toValue = @1;
    strockAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_progressCanvas addAnimation:strockAnimation forKey:@"strockAnimation"];
    
    CAKeyframeAnimation * positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = duration;
    positionAnimation.path = _progressCanvas.path;
    positionAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.pointLayer addAnimation:positionAnimation forKey:@"positionAnimation"];
    
    [self.animator startAnimationWithDuration:duration animationArray:@[self.numbeRrenderer] updateBlock:^(CGFloat progress) {
        
        [self setNeedsDisplay];
    }];
}

/**
 * 中心圆点
 */
- (CALayer *)pointLayer
{
    if (_pointLayer == nil) {
        
        _pointLayer = [CALayer new];
        [self addSublayer:_pointLayer];
    }
    
    return _pointLayer;
}

/**
 * 中间文字渲染器
 */
- (GGNumberRenderer *)numbeRrenderer
{
    if (_numbeRrenderer == nil) {
        
        _numbeRrenderer = [[GGNumberRenderer alloc] init];
        [self addRenderer:_numbeRrenderer];
    }
    
    return _numbeRrenderer;
}

GGLazyGetMethod(Animator, animator);

@end
