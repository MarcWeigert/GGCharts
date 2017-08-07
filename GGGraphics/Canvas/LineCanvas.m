//
//  LineCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineCanvas.h"
#import "DLineScaler.h"

@interface LineCanvas ()

@property (nonatomic, strong) GGCanvas * stringCanvas;

@end

@implementation LineCanvas

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _stringCanvas = [[GGCanvas alloc] init];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _stringCanvas.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)drawChart
{
    [super drawChart];
    
    [_stringCanvas removeAllRenderer];
    
    CGRect rect = CGRectMake(0, 0, self.gg_width, self.gg_height);
    rect = UIEdgeInsetsInsetRect(rect, [_lineDrawConfig lineInsets]);
    
    for (NSInteger i = 0; i < _lineDrawConfig.lineAry.count; i++) {
        
        id <LineDrawAbstract> lineDraw = _lineDrawConfig.lineAry[i];
        
        DLineScaler * lineScaler = [lineDraw lineScaler];
        lineScaler.rect = rect;
        lineScaler.xRatio = 0;
        
        if ([_lineDrawConfig isGroupingAlignment]) {
            
            lineScaler.xRatio = (float)(i + 1) / ([[_lineDrawConfig lineAry] count] + 1);
        }
        else if ([_lineDrawConfig isCenterAlignment]) {
        
            lineScaler.xRatio = .5f;
        }
        
        [lineScaler updateScaler];
        
        [self drawFillChartWithDraw:lineDraw];
        [self drawLineChartWithLineDraw:lineDraw];
        [self drawShapeChartWithLineDraw:lineDraw];
        [self drawStringChartWithDraw:lineDraw];
    }
    
    [self addSublayer:_stringCanvas];
    [_stringCanvas setNeedsDisplay];
}

- (void)drawLineChartWithLineDraw:(id <LineDrawAbstract>)lineDraw
{
    DLineScaler * lineScaler = lineDraw.lineScaler;
    
    GGShapeCanvas * shape = [self getGGCanvasEqualFrame];
    shape.lineWidth = [lineDraw lineWidth];
    shape.strokeColor = [lineDraw lineColor].CGColor;
    shape.fillColor = [UIColor clearColor].CGColor;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddLines(path, NULL, lineScaler.linePoints, lineScaler.pointSize);
    shape.path = path;
    CGPathRelease(path);
}

- (void)drawShapeChartWithLineDraw:(id <LineDrawAbstract>)lineDraw
{
    if ([lineDraw shapeRadius] > 0) {
        
        DLineScaler * lineScaler = lineDraw.lineScaler;
        
        GGShapeCanvas * shape = [self getGGCanvasEqualFrame];
        shape.lineWidth = [lineDraw lineWidth];
        shape.strokeColor = [lineDraw lineColor].CGColor;
        shape.fillColor = [lineDraw shapeFillColor] == nil ? [UIColor whiteColor].CGColor : [lineDraw shapeFillColor].CGColor;
        
        CGMutablePathRef path = CGPathCreateMutable();
        GGPathAddCircles(path, lineScaler.linePoints, [lineDraw shapeRadius], lineScaler.pointSize);
        shape.path = path;
        CGPathRelease(path);
    }
}

- (void)drawStringChartWithDraw:(id <LineDrawAbstract>)lineDraw
{
    if ([lineDraw stringFont] != nil) {
        
        NSString * dataFromatter = [lineDraw dataFormatter] == nil ? @"%.2f" : [lineDraw dataFormatter];
        DLineScaler * lineScaler = lineDraw.lineScaler;
        
        for (NSInteger i = 0; i < lineScaler.dataAry.count; i++) {
            
            GGStringRenderer * stringRenderer = [[GGStringRenderer alloc] init];
            stringRenderer.color = [lineDraw lineColor];
            stringRenderer.point = lineScaler.linePoints[i];
            stringRenderer.font = [lineDraw stringFont];
            stringRenderer.string = [NSString stringWithFormat:dataFromatter, [lineScaler.dataAry[i] floatValue]];
            stringRenderer.offSetRatio = CGPointMake(-.5f, -1.2f);
            [_stringCanvas addRenderer:stringRenderer];
        }
    }
}

- (void)drawFillChartWithDraw:(id <LineDrawAbstract>)lineDraw
{
    if ([lineDraw lineFillColor]) {
        
        DLineScaler * lineScaler = lineDraw.lineScaler;
        
        GGShapeCanvas * shape = [self getGGCanvasEqualFrame];
        shape.lineWidth = 0;
        shape.fillColor = [lineDraw lineFillColor].CGColor;
        
        CGFloat bottomY = [lineDraw fillRoundPrice] == nil ? CGRectGetMaxY(lineScaler.rect) : [lineScaler getYPixelWithData:[lineDraw fillRoundPrice].floatValue];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddLines(path, NULL, lineScaler.linePoints, lineScaler.pointSize);
        CGPathAddLineToPoint(path, NULL, lineScaler.linePoints[lineScaler.pointSize - 1].x, bottomY);
        CGPathAddLineToPoint(path, NULL, lineScaler.linePoints[0].x, bottomY);
        CGPathCloseSubpath(path);
        shape.path = path;
        CGPathRelease(path);
    }
}

@end
