//
//  GGPieLayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/10/18.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGPieLayer.h"

typedef enum : NSUInteger {
    LineStrokeStart,
    LineStrokeEnd,
} LineStrokeType;

@interface GGPieLayer () <CAAnimationDelegate>

/**
 * 中心点
 */
@property (nonatomic, assign) CGPoint pieCenter;

/**
 * 扇形开角
 */
@property (nonatomic, assign) CGFloat pieArc;

/**
 * 扇形旋转角度
 */
@property (nonatomic, assign) CGFloat pieTransform;

/**
 * 内环半径
 */
@property (nonatomic, assign) CGFloat inRadius;

/**
 * 外环半径
 */
@property (nonatomic, assign) CGFloat outRadius;

/**
 * 当前线性路径
 */
@property (nonatomic, assign) CGPathRef linePath;

/**
 * 动画Key
 */
@property (nonatomic, strong) NSSet * keyAnimations;

/**
 * 动画进度条
 */
@property (nonatomic, assign) CGFloat progress;

/**
 * 旧扇形路径
 */
@property (nonatomic, assign) GGPie oldPie;

/**
 * 对象
 */
@property (nonatomic, assign) LineStrokeType strokeType;

@end

@implementation GGPieLayer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.contentsScale = [[UIScreen mainScreen] scale];
        self.progress = 1.0f;
        self.numberRenderer = [GGNumberRenderer new];
        self.pie = GGPieZero;
        self.oldPie = GGPieZero;
    }
    
    return self;
}

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"pieArc"] ||
        [key isEqualToString:@"pieTransform"] ||
        [key isEqualToString:@"inRadius"] ||
        [key isEqualToString:@"outRadius"] ||
        [key isEqualToString:@"linePath"] ||
        [key isEqualToString:@"progress"]) {
        
        return YES;
    }
    
    return [super needsDisplayForKey:key];
}

- (void)addAnimation:(CAAnimation *)anim forKey:(NSString *)key
{
    [super addAnimation:anim forKey:key];
    
    NSMutableSet * keysSet = [NSMutableSet set];
    
    if ([anim isKindOfClass:[CAPropertyAnimation class]]) {
        
        [keysSet addObject:[(CAPropertyAnimation *)anim keyPath]];
    }
    
    if ([anim isKindOfClass:[CAAnimationGroup class]]) {
        
        for (CAAnimation * animation in [(CAAnimationGroup *)anim animations]) {
            
            if ([animation isKindOfClass:[CAPropertyAnimation class]]) {
                
                [keysSet addObject:[(CAPropertyAnimation *)animation keyPath]];
            }
        }
    }
    
    _keyAnimations = [NSSet setWithSet:keysSet];
}

- (void)setPie:(GGPie)pie
{
    if (!GGPieIsEmpty(_pie)) {
        
        _oldPie = _pie;
    }
    
    _pie = pie;
    _pieArc = pie.arc;
    _pieTransform = pie.transform;
    _pieCenter = pie.center;
    _inRadius = pie.radiusRange.inRadius;
    _outRadius = pie.radiusRange.outRadius;
}

- (GGPie)currentPie
{
    return GGPieMake(_pieCenter.x, _pieCenter.y, _inRadius, _outRadius, _pieArc, _pieTransform);
}

- (void)setNeedsDisplay
{
    [super setNeedsDisplay];
    
    CGFloat endRadius = [_outSideLable linePointRadius];
    CGFloat pieLineSpacing = [_outSideLable lineSpacing];
    CGFloat pieLineLength = [_outSideLable lineLength];
    CGFloat pieInflectionLength = [_outSideLable inflectionLength];
    CGFloat maxLineLength = _pie.radiusRange.outRadius + pieLineSpacing + pieLineLength;
    
    CGPoint draw_center = _pie.center;
    GGArcLine arcLine = GGArcLineMake(draw_center, _pie.transform + _pie.arc / 2, maxLineLength);
    GGLine line = GGLineWithArcLine(arcLine, false);
    GGLine line_m = GGLineMoveStart(line, _pie.radiusRange.outRadius + pieLineSpacing);
    CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, pieInflectionLength);
    GGCircle circle = GGCirclePointMake(end_pt, endRadius);
    
    CGMutablePathRef ref = CGPathCreateMutable();
    GGPathAddCircle(ref, circle);
    GGPathAddLine(ref, line_m);
    CGPathMoveToPoint(ref, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref, NULL, end_pt.x, end_pt.y);
    [self setLinePath:ref];
    CGPathRelease(ref);
    
    GGPie pie = _pie;
    CGFloat base = GGPieLineYCircular(pie) > 0 ? 1 : -1;
    self.numberRenderer.offSetRatio = CGPointMake([_outSideLable stringRatio].x * base, [_outSideLable stringRatio].y);
    self.numberRenderer.offSet = CGSizeMake([_outSideLable stringOffSet].width * base, [_outSideLable stringOffSet].height);
    self.numberRenderer.toPoint = end_pt;
    [self.numberRenderer drawAtToNumberAndPoint];
}

/**
 * 设置扇形图Pie路径
 */
- (void)setLinePath:(CGPathRef)path
{
    if (_linePath != nil) {
        
        CGPathRelease(_linePath);
    }
    
    _linePath = path;
    CGPathRetain(_linePath);
}

- (void)dealloc
{    
    CGPathRelease(_linePath);
}

- (id)initWithLayer:(id)layer
{
    self = [super initWithLayer:layer];
    
    if (self) {
        
        if ([layer isKindOfClass:[GGPieLayer class]]) {
            
            GGPieLayer *other = (GGPieLayer *)layer;
            self.pieArc = other.pieArc;
            self.pieTransform = other.pieTransform;
            self.pieCenter = other.pieCenter;
            self.inRadius = other.inRadius;
            self.outRadius = other.outRadius;
            self.pie = other.pie;
            self.linePath = other.linePath;
            self.keyAnimations = other.keyAnimations;
            self.progress = other.progress;
            self.numberRenderer = other.numberRenderer;
            self.outSideLable = other.outSideLable;
            self.showOutLableType = other.showOutLableType;
            self.oldPie = other.oldPie;
            self.pieColor = other.pieColor;
            self.gradientCurve = other.gradientCurve;
            self.gradientLocations = other.gradientLocations;
            self.gradientColors = other.gradientColors;
            self.lineColor = other.lineColor;
        }
    }
    
    return self;
}

- (nullable id<CAAction>)actionForKey:(NSString *)event
{
    return nil;
}

/**
 * 绘制扇形
 */
- (void)drawArcInContext:(CGContextRef)ctx
{
    CGFloat startArc = _pieTransform;
    CGFloat endArc = _pieTransform + _pieArc;
    CGFloat minRadius = _inRadius;
    CGFloat maxRadius = _outRadius;
    
    if (self.gradientColors.count > 0) {
        
        CGPoint start = CGPointZero;
        CGPoint end = CGPointZero;
        
        CGFloat radius_ratio = .15f;
        CGFloat outSide = (_pie.radiusRange.outRadius - _pie.radiusRange.inRadius) * radius_ratio;
        CGFloat maxWidth = _pie.radiusRange.outRadius + outSide;
        
        CGRect rect = CGRectMake(_pieCenter.x - maxWidth, _pieCenter.y - maxWidth, maxWidth * 2, maxWidth * 2);
        
        start = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y);
        end = CGPointMake(rect.origin.x + rect.size.width / 2, rect.origin.y + rect.size.height);
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)_gradientColors.getCGColorsArray, nil);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, NULL, _pieCenter.x, _pieCenter.y, minRadius, startArc, endArc, false);
        CGPathAddArc(path, NULL, _pieCenter.x, _pieCenter.y, maxRadius, endArc, startArc, true);
        CGPathCloseSubpath(path);
        
        CGContextSaveGState(ctx);
        CGContextAddPath(ctx, path);
        CGContextClip(ctx);
        CGContextDrawLinearGradient(ctx, gradient, start, end, 0);
        CGContextRestoreGState(ctx);
        
        CGGradientRelease(gradient);
        CGColorSpaceRelease(colorSpace);
    }
    else {
        
        CGContextBeginPath(ctx);
        CGContextAddArc(ctx, _pieCenter.x, _pieCenter.y, minRadius, startArc, endArc, false);
        CGContextAddArc(ctx, _pieCenter.x, _pieCenter.y, maxRadius, endArc, startArc, true);
        CGContextClosePath(ctx);
        CGContextDrawPath(ctx, kCGPathFill);
    }
}

/**
 * 绘制跟踪线
 */
- (void)drawLineInContext:(CGContextRef)ctx
{
    CGFloat spacing = [_outSideLable lineSpacing];
    CGFloat pieLineLength = [_outSideLable lineLength];
    CGFloat line2 = [_outSideLable inflectionLength];
    CGFloat line1 = _outRadius + spacing + pieLineLength;
    CGFloat end_radius = [_outSideLable linePointRadius];
    
    // 跟踪扇形动画
    CGPoint draw_center = _pieCenter;
    GGArcLine arcLine = GGArcLineMake(draw_center, _pieTransform + _pieArc / 2, line1);
    GGLine line = GGLineWithArcLine(arcLine, false);
    GGLine line_m = GGLineMoveStart(line, _outRadius + spacing);
    CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, line2);
    CGRect circleRect = CGRectMake(end_pt.x - end_radius, end_pt.y - end_radius, end_radius * 2, end_radius * 2);
    
    self.numberRenderer.toPoint = end_pt;
    
    CGContextAddEllipseInRect(ctx, circleRect);
    CGContextFillPath(ctx);
    CGContextMoveToPoint(ctx, line_m.start.x, line_m.start.y);
    CGContextAddLineToPoint(ctx, line_m.end.x, line_m.end.y);
    CGContextMoveToPoint(ctx, line_m.end.x, line_m.end.y);
    CGContextAddLineToPoint(ctx, end_pt.x, end_pt.y);
    CGContextStrokePath(ctx);
}

/**
 * 父类上下文绘制
 */
- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    CGContextSetLineWidth(ctx, 1.0f);
    
    if (!self.numberRenderer.hidden) {  // 隐藏外线则不绘制
        
        if ([_keyAnimations containsObject:@"linePath"]) {
            
            CGContextSetFillColorWithColor(ctx, _lineColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx, _lineColor.CGColor);
            
            CGContextAddPath(ctx, self.linePath);
            CGContextStrokePath(ctx);
            
            CGContextAddPath(ctx, self.linePath);
            CGContextFillPath(ctx);
        }
        else {
            
            CGContextSetFillColorWithColor(ctx, _lineColor.CGColor);
            CGContextSetStrokeColorWithColor(ctx, _lineColor.CGColor);
            
            [self drawLineInContext:ctx];
            
            GGPie pie = [self currentPie];
            CGFloat base = GGPieLineYCircular(pie) > 0 ? 1 : -1;
            
            self.numberRenderer.offSetRatio = CGPointMake([_outSideLable stringRatio].x * base, [_outSideLable stringRatio].y);
            self.numberRenderer.offSet = CGSizeMake([_outSideLable stringOffSet].width * base, [_outSideLable stringOffSet].height);
        }
        
        [self.numberRenderer startUpdateNumberWithProgress:self.progress];
        [self.numberRenderer drawAtToPoint];
        [self.numberRenderer drawInContext:ctx];
    }
    
    CGContextSetFillColorWithColor(ctx, _pieColor.CGColor);
    CGContextSetStrokeColorWithColor(ctx, _pieColor.CGColor);
    
    [self drawArcInContext:ctx];
}

#pragma mark - Animations

/**
 * 进度动画
 */
- (CABasicAnimation *)basicProgerssAnimation
{
    CABasicAnimation * progressAnimation = [CABasicAnimation animationWithKeyPath:@"progress"];
    progressAnimation.fromValue = @0;
    progressAnimation.toValue = @1;
    
    return progressAnimation;
}

/**
 * 扇形图曲线动画
 *
 * @param duration 动画时长
 */
- (void)startPieChangeAnimationWithDuration:(NSTimeInterval)duration
{
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"pieArc"];
    basicAnimation.fromValue = @(_oldPie.arc);
    basicAnimation.toValue = @(_pie.arc);
    
    CABasicAnimation * basicTrasAnimation = [CABasicAnimation animationWithKeyPath:@"pieTransform"];
    basicTrasAnimation.fromValue = @(_oldPie.transform);
    basicTrasAnimation.toValue = @(_pie.transform);
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[basicAnimation, basicTrasAnimation, [self basicProgerssAnimation]];
    groupAnimation.duration = duration;
    
    [self addAnimation:groupAnimation forKey:@"pieChangeAnimations"];
}

/**
 * 扇形图伸展动画
 *
 * @param duration 动画时长
 */
- (void)startPieOutRadiusLargeWithDuration:(NSTimeInterval)duration
{
    CGFloat radius_ratio = .1f;
    CGFloat outSide = (_pie.radiusRange.outRadius - _pie.radiusRange.inRadius) * radius_ratio;
    CGFloat maxWidth = _pie.radiusRange.outRadius + outSide;
    
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"outRadius"];
    basicAnimation.fromValue = @(_outRadius);
    basicAnimation.toValue = @(maxWidth);
    _outRadius = maxWidth;
    basicAnimation.duration = duration;
    
    [self addAnimation:basicAnimation forKey:@"basicLargeAnimation"];
}

/**
 * 扇形图缩小动画
 *
 * @param duration 动画时长
 */
- (void)startPieOutRadiusSmallWithDuration:(NSTimeInterval)duration
{
    CGFloat radius_ratio = .1f;
    CGFloat outSide = (_pie.radiusRange.outRadius - _pie.radiusRange.inRadius) * radius_ratio;
    CGFloat maxWidth = _pie.radiusRange.outRadius + outSide;
    
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"outRadius"];
    basicAnimation.fromValue = @(maxWidth);
    basicAnimation.toValue = @(_pie.radiusRange.outRadius);
    basicAnimation.duration = duration;
    _outRadius = _pie.radiusRange.outRadius;
    [self addAnimation:basicAnimation forKey:@"basicSmallAnimation"];
}

/**
 * 扇形图曲线动画
 *
 * @param duration 动画时长
 */
- (void)startPieLineStrokeStartAnimationWithDuration:(NSTimeInterval)duration
{
    CGFloat endRadius = [_outSideLable linePointRadius];
    CGFloat pieLineSpacing = [_outSideLable lineSpacing];
    CGFloat pieLineLength = [_outSideLable lineLength];
    CGFloat pieInflectionLength = [_outSideLable inflectionLength];
    CGFloat maxLineLength = _pie.radiusRange.outRadius + pieLineSpacing + pieLineLength;
    
    //self.strokeType = LineStrokeStart;
    self.numberRenderer.hidden = !(_showOutLableType == OutSideSelect);
    
    CAKeyframeAnimation * keyPathFrameAnimations = [CAKeyframeAnimation animationWithKeyPath:@"linePath"];
    keyPathFrameAnimations.values = GGPieLineStretch(_pie, maxLineLength, pieInflectionLength, endRadius, pieLineSpacing);
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[keyPathFrameAnimations, [self basicProgerssAnimation]];
    groupAnimation.duration = duration;
    groupAnimation.delegate = self;
    [self addAnimation:groupAnimation forKey:@"strokeStartGroupAnimation"];
}

/**
 * 扇形图曲线动画
 *
 * @param duration 动画时长
 */
- (void)startPieLineStrokeEndAnimationWithDuration:(NSTimeInterval)duration
{
    self.strokeType = LineStrokeEnd;
    self.numberRenderer.hidden = _showOutLableType != OutSideShow;;
    [self setNeedsDisplay];
}

/**
 * 扇形图曲线动画
 *
 * @param duration 动画时长
 * @param transform 旋转动画
 */
- (void)startTransformArcAddWithDuration:(NSTimeInterval)duration baseTransform:(CGFloat)transform
{
    CGFloat endRadius = [_outSideLable linePointRadius];
    CGFloat pieLineSpacing = [_outSideLable lineSpacing];
    CGFloat pieLineLength = [_outSideLable lineLength];
    CGFloat pieInflectionLength = [_outSideLable inflectionLength];
    CGFloat maxLineLength = _pie.radiusRange.outRadius + pieLineSpacing + pieLineLength;
    
    CAKeyframeAnimation * keyPathFrameAnimations = [CAKeyframeAnimation animationWithKeyPath:@"linePath"];
    keyPathFrameAnimations.values = GGPieLineStretch(_pie, maxLineLength, pieInflectionLength, endRadius, pieLineSpacing);
    
    CABasicAnimation * basicAnimation = [CABasicAnimation animationWithKeyPath:@"pieArc"];
    basicAnimation.fromValue = @0;
    basicAnimation.toValue = @(_pie.arc);
    
    CABasicAnimation * basicTrasAnimation = [CABasicAnimation animationWithKeyPath:@"pieTransform"];
    basicTrasAnimation.fromValue = @(transform);
    basicTrasAnimation.toValue = @(_pie.transform);
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[basicAnimation, basicTrasAnimation, keyPathFrameAnimations, [self basicProgerssAnimation]];
    groupAnimation.duration = duration;
    
    [self addAnimation:groupAnimation forKey:@"groupAnimation"];
}

/**
 * 扇形图弹射动画
 *
 * @param duration 动画时长
 */
- (void)startEjectAnimationWithDuration:(NSTimeInterval)duration
{
    CGFloat endRadius = [_outSideLable linePointRadius];
    CGFloat pieLineSpacing = [_outSideLable lineSpacing];
    CGFloat pieLineLength = [_outSideLable lineLength];
    CGFloat pieInflectionLength = [_outSideLable inflectionLength];
    CGFloat maxLineLength = _pie.radiusRange.outRadius + pieLineSpacing + pieLineLength;

    CAKeyframeAnimation * keyPathFrameAnimations = [CAKeyframeAnimation animationWithKeyPath:@"linePath"];
    keyPathFrameAnimations.values = GGPieLineStretch(_pie, maxLineLength, pieInflectionLength, endRadius, pieLineSpacing);

    NSMutableArray * array = [NSMutableArray array];
    
    CGFloat radius_ratio = .15f;
    CGFloat frame = duration * 60;
    CGFloat out_frame = frame * (1.0f - radius_ratio);
    CGFloat in_frame = frame * radius_ratio;
    
    CGFloat outSide = (_pie.radiusRange.outRadius - _pie.radiusRange.inRadius) * radius_ratio;
    CGFloat full_radius = (_pie.radiusRange.outRadius - _pie.radiusRange.inRadius + outSide);
    CGFloat frame_radius = full_radius / out_frame;
    CGFloat in_frame_radius = outSide / in_frame;
    
    for (long i = 0; i < out_frame; i++) {
        
        [array addObject:@(_pie.radiusRange.inRadius + frame_radius * i)];
    }
    
    for (long i = 0; i < in_frame; i++) {
        
        [array addObject:@(_pie.radiusRange.inRadius + full_radius - (in_frame_radius * i))];
    }
    
    CAKeyframeAnimation * keyOutSideAnimations = [CAKeyframeAnimation animationWithKeyPath:@"outRadius"];
    keyOutSideAnimations.values = array;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[keyPathFrameAnimations, keyOutSideAnimations, [self basicProgerssAnimation]];
    groupAnimation.duration = duration;
    groupAnimation.delegate = self;
    groupAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self addAnimation:groupAnimation forKey:@"groupAnimation"];
}

#pragma mark - Animation Delegate

- (void)animationDidStart:(CAAnimation *)anim
{
    self.hidden = NO;
}

@end
