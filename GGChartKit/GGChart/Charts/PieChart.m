//
//  PieChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieChart.h"
#import "GGChartGeometry.h"
#import "CGPathCategory.h"
#import "GGCircleRenderer.h"
#import "UICountingLabel.h"
#include "GGChartDefine.h"
#import "DPieScaler.h"
#import "CALayer+GGFrame.h"
#import "GGStringRenderer.h"

@interface PieChart ()

@property (nonatomic, strong) DPieScaler * pieScaler;

@property (nonatomic, strong) GGCircleRenderer * rendererAnnular;
@property (nonatomic, strong) GGCircleRenderer * rendererCircular;
@property (nonatomic, strong) GGStringRenderer * rendererString;

@property (nonatomic, strong) GGCanvas * annularCanvas;
@property (nonatomic, strong) GGCanvas * circularCanvas;

@end

@implementation PieChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _attachedString = @"万元";
        _format = @"%.0f";
        _titleFont = [UIFont systemFontOfSize:10];
        _perFont = [UIFont systemFontOfSize:16];
        
        _rendererAnnular = [[GGCircleRenderer alloc] init];
        _rendererAnnular.borderWidth = 0.7;
        _rendererAnnular.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        
        _rendererCircular = [[GGCircleRenderer alloc] init];
        _rendererCircular.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:.5f];
        
        _rendererString = [[GGStringRenderer alloc] init];
        _rendererString.font = [UIFont systemFontOfSize:16];
        _rendererString.color = [UIColor whiteColor];
        _rendererString.offSetRatio = CGPointMake(-.5f, -.5f);
        
        _annularCanvas = [[GGCanvas alloc] init];
        [_annularCanvas addRenderer:_rendererAnnular];
        [self.layer addSublayer:_annularCanvas];
        
        _circularCanvas = [[GGCanvas alloc] init];
        [_circularCanvas addRenderer:_rendererCircular];
        [_circularCanvas addRenderer:_rendererString];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _annularCanvas.frame = CGRectMake(0, 0, self.layer.gg_width, self.layer.gg_height);
    _circularCanvas.frame = _annularCanvas.frame;
}

- (void)setDataAry:(NSArray<PieData *> *)dataAry
{
    _dataAry = dataAry;
    
    [self.pieScaler setObjAry:dataAry getSelector:@selector(data)];
}

- (void)drawChart
{
    [super drawChart];
    
    [self.pieScaler updateScaler];
    [self drawPieChart];
    [self drawSpiderLine];
    
    [self drawBackCanvas];
}

- (void)drawBackCanvas
{
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    _rendererAnnular.circle = GGCirclePointMake(center, _radius + 4);
    [self.layer addSublayer:_annularCanvas];
    [_annularCanvas setNeedsDisplay];
    
    _rendererString.point = center;
    _rendererString.string = @"今日\n资金";
    _rendererCircular.circle = GGCirclePointMake(center, _radius / 5 * 2.2);
    [self.layer addSublayer:_circularCanvas];
    [_circularCanvas setNeedsDisplay];
}

- (void)drawPieChart
{
    [_dataAry enumerateObjectsUsingBlock:^(PieData * obj, NSUInteger idx, BOOL * stop) {
        
        // pie 图表
        GGShapeCanvas * shape = [self getGGCanvasSquareFrame];
        shape.fillColor = obj.color.CGColor;
        shape.strokeColor = obj.color.CGColor;
        shape.lineWidth = 0;
        obj.shapeCanvas = shape;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPoint center = CGPointMake(shape.gg_width / 2, shape.gg_height / 2);
        GGSector sector = GGSectorCenterMake(center, 0, self.pieScaler.arcs[idx], _radius);
        GGPathAddSector(ref, sector);
        shape.path = ref;
        CGPathRelease(ref);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        shape.affineTransform = CGAffineTransformRotate(transform, self.pieScaler.transArcs[idx]);
    }];
}

/** 设置文字 */
- (NSAttributedString *)attrStringForIndex:(NSInteger)index value:(CGFloat)value
{
    NSString * formatString = [NSString stringWithFormat:@"%@%@", _format, _attachedString];
    NSString * dataString = [NSString stringWithFormat:formatString, [_dataAry[index] data]];
    NSString * nameString = [_dataAry[index] pieName];
    NSString * valueString = [NSString stringWithFormat:@"%d%%", (int)(value * 100)];
    NSString * string = [NSString stringWithFormat:@"%@\n%@\n%@", nameString, valueString, dataString];
    
    NSRange rgData = [string rangeOfString:dataString];
    NSRange rgName = [string rangeOfString:nameString];
    NSRange rgValue = [string rangeOfString:valueString];
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:3];
    
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:paragraphStyle
                       range:NSMakeRange(0, [string length])];

    [attrString addAttribute:NSFontAttributeName
                       value:_titleFont
                       range:rgData];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:rgData];
    
    [attrString addAttribute:NSFontAttributeName
                       value:_titleFont
                       range:rgName];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[UIColor blackColor]
                       range:rgName];
    
    [attrString addAttribute:NSFontAttributeName
                       value:_perFont
                       range:rgValue];
    
    [attrString addAttribute:NSForegroundColorAttributeName
                       value:[_dataAry[index] color]
                       range:rgValue];
    
    return attrString;
    
}

- (void)drawSpiderLine
{
    [_dataAry enumerateObjectsUsingBlock:^(PieData * obj, NSUInteger idx, BOOL * stop) {
        
        GGShapeCanvas * shapeSpa = [self getGGCanvasEqualFrame];
        shapeSpa.lineWidth = 1;
        shapeSpa.fillColor = obj.color.CGColor;
        shapeSpa.strokeColor = obj.color.CGColor;
        obj.spiderCanvas = shapeSpa;
        
        CGMutablePathRef refs = CGPathCreateMutable();
        CGPoint draw_center = CGPointMake(shapeSpa.frame.size.width / 2, shapeSpa.frame.size.height / 2);
        GGArcLine arcLine = GGArcLineMake(draw_center, self.pieScaler.transArcs[idx] + self.pieScaler.arcs[idx] / 2, _radius + 30);
        GGLine line = GGLineWithArcLine(arcLine, false);
        GGLine line_m = GGLineMoveStart(line, _radius + 10);
        CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, 10);
        GGCircle circle = GGCirclePointMake(end_pt, 2);
        GGPathAddCircle(refs, circle);
        GGPathAddLine(refs, line_m);
        CGPathMoveToPoint(refs, NULL, line_m.end.x, line_m.end.y);
        CGPathAddLineToPoint(refs, NULL, end_pt.x, end_pt.y);
        shapeSpa.path = refs;
        CGPathRelease(refs);
        
        NSAttributedString * attrString = [self attrStringForIndex:idx value:self.pieScaler.ratios[idx]];
        CGFloat line_arc = GGYCircular(line);
        CGFloat center_offset = attrString.size.width / 2 + 4;
        CGFloat center_x = line_arc > 0 ? end_pt.x + center_offset : end_pt.x - center_offset;
        [self drawCountLableWithCenter:CGPointMake(center_x, end_pt.y) index:idx attrString:attrString];
        
        [shapeSpa registerKeyAnimation:@"path"
                                  name:@"spiderLineAnimation"
                                values:[self spiderLineAnimation:line_m circle:circle]];

    }];
}

- (void)drawCountLableWithCenter:(CGPoint)center index:(NSInteger)idx attrString:(NSAttributedString *)string
{
    UICountingLabel * lbCount = [self getGGCountLable];
    lbCount.attributedText = string;
    lbCount.numberOfLines = 0;
    [lbCount sizeToFit];
    
    __weak PieChart * weakSelf = self;
    lbCount.attributedFormatBlock = ^NSAttributedString *(CGFloat value) {
        
        return [weakSelf attrStringForIndex:idx value:value];
    };
    
    lbCount.center = center;
}

- (void)addAnimationWithDuration:(NSTimeInterval)duration
{
    [_dataAry enumerateObjectsUsingBlock:^(PieData * obj, NSUInteger idx, BOOL * stop) {
        
        CAKeyframeAnimation * transAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation"];
        transAnimation.duration = duration;
        transAnimation.values = @[@(-M_PI_2), @(self.pieScaler.transArcs[idx])];
        [obj.shapeCanvas addAnimation:transAnimation forKey:@"transAnimation"];
        
        CAKeyframeAnimation * scaleAtnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
        scaleAtnimation.duration = duration;
        scaleAtnimation.values = @[@0, @1];
        [obj.shapeCanvas addAnimation:scaleAtnimation forKey:@"scaleAtnimation"];
        [self.annularCanvas addAnimation:scaleAtnimation forKey:@"scaleAtnimation"];
        [self.circularCanvas addAnimation:scaleAtnimation forKey:@"scaleAtnimation"];
        
        CGFloat width = self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
        CGPoint center = CGPointMake(width / 2, width / 2);
        GGSector sector = GGSectorCenterMake(center, 0, self.pieScaler.arcs[idx], _radius);
        CAKeyframeAnimation * pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"path"];
        pathAnimation.duration = duration;
        pathAnimation.values = GGPathAnimationArrayFor(sector, duration * 60 * 10);
        [obj.shapeCanvas addAnimation:pathAnimation forKey:@"pathAnimation"];
        
        [obj.spiderCanvas startAnimation:@"spiderLineAnimation" duration:duration];
    }];
    
    [self.visibleLables enumerateObjectsUsingBlock:^(UICountingLabel * obj, NSUInteger idx, BOOL * stop) {
        
        [obj countFrom:0 to:_pieScaler.ratios[idx] withDuration:duration];
    }];
}

- (NSArray *)spiderLineAnimation:(GGLine)line_m circle:(GGCircle)circle
{
    CGMutablePathRef ref1 = CGPathCreateMutable();
    CGMutablePathRef ref2 = CGPathCreateMutable();
    CGMutablePathRef ref3 = CGPathCreateMutable();
    CGMutablePathRef ref4 = CGPathCreateMutable();
    CGMutablePathRef ref5 = CGPathCreateMutable();
    CGMutablePathRef ref6 = CGPathCreateMutable();
    
    CGPathMoveToPoint(ref1, NULL, line_m.start.x, line_m.start.y);
    
    CGPathMoveToPoint(ref2, NULL, line_m.start.x, line_m.start.y);
    CGPathAddLineToPoint(ref2, NULL, line_m.end.x, line_m.end.y);
    
    GGPathAddLine(ref3, line_m);
    CGPathMoveToPoint(ref3, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref3, NULL, circle.center.x, circle.center.y);
    
    GGPathAddLine(ref4, line_m);
    CGPathMoveToPoint(ref4, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref4, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref4, circle);
    
    GGPathAddLine(ref5, line_m);
    CGPathMoveToPoint(ref5, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref5, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref5, GGCirclePointMake(circle.center, 2.5));
    
    GGPathAddLine(ref6, line_m);
    CGPathMoveToPoint(ref6, NULL, line_m.end.x, line_m.end.y);
    CGPathAddLineToPoint(ref6, NULL, circle.center.x, circle.center.y);
    GGPathAddCircle(ref6, circle);
    
    NSArray * paths = @[(__bridge id)ref1, (__bridge id)ref2, (__bridge id)ref3,
                        (__bridge id)ref4, (__bridge id)ref5, (__bridge id)ref6];
    
    CFRelease(ref1);
    CFRelease(ref2);
    CFRelease(ref3);
    CFRelease(ref4);
    CFRelease(ref5);
    CFRelease(ref6);

    return paths;
}

#pragma mark - Lazy

GGLazyGetMethod(DPieScaler, pieScaler);

@end
