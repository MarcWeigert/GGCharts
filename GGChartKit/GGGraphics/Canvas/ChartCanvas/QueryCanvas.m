//
//  QueryCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "QueryCanvas.h"

@interface QueryCanvas ()

@property (nonatomic, strong) GGStringRenderer * xTopAxisLable;
@property (nonatomic, strong) GGStringRenderer * yLeftAxisLable;
@property (nonatomic, strong) GGStringRenderer * xBottomAxisLable;
@property (nonatomic, strong) GGStringRenderer * yRightAxisLable;

@property (nonatomic, strong) GGLineRenderer * xLine;
@property (nonatomic, strong) GGLineRenderer * yLine;

@end

@implementation QueryCanvas

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.isCloseDisableActions = YES;
    }
    
    return self;
}

- (void)setQueryDrawConfig:(id<QueryAbstract>)queryDrawConfig
{
    _queryDrawConfig = queryDrawConfig;
    
    [self removeAllRenderer];
    [self configLineRenderers];
    [self configAxisRenderers];
}

/**
 * 配置线
 */
- (void)configLineRenderers
{
    NSArray * lineAry = @[self.xLine, self.yLine];
    
    for (GGLineRenderer * lineRenderer in lineAry) {
        
        lineRenderer.dashPattern = [_queryDrawConfig dashPattern];
        lineRenderer.color = [_queryDrawConfig lineColor];
        lineRenderer.width = [_queryDrawConfig lineWidth];
        [self addRenderer:lineRenderer];
    }
    
    if (![[_queryDrawConfig leftNumberAxis] showQueryLable] &&
        ![[_queryDrawConfig rightNumberAxis] showQueryLable]) {
        
        [self removeRenderer:self.yLine];
    }
}

/** 
 * 轴配置 
 */
- (void)configAxisRenderers
{
    CGRect drawRect = UIEdgeInsetsInsetRect(self.frame, [_queryDrawConfig insets]);
    
    NSArray * aryStringRenderders = @[self.yLeftAxisLable, self.yRightAxisLable, self.xTopAxisLable, self.xBottomAxisLable];
    NSArray * aryAxisAbstract = @[[_queryDrawConfig leftNumberAxis], [_queryDrawConfig rightNumberAxis], [_queryDrawConfig topLableAxis], [_queryDrawConfig bottomLableAxis]];
    
    for (NSInteger i = 0; i < aryStringRenderders.count; i++) {
        
        GGStringRenderer * renderer = aryStringRenderders[i];
        id <BaseAxisAbstract> baseAxis = aryAxisAbstract[i];
        
        if ([baseAxis showQueryLable]) {
            
            renderer.edgeInsets = [_queryDrawConfig lableInsets];
            renderer.fillColor = [_queryDrawConfig lableBackgroundColor];
            renderer.color = [_queryDrawConfig lableColor];
            renderer.font = [_queryDrawConfig lableFont];
            renderer.offSetRatio = [baseAxis offSetRatio];
            [self addRenderer:renderer];
            
            if ([renderer isEqual:self.yLeftAxisLable] ||
                [renderer isEqual:self.yRightAxisLable]) {
                
                renderer.verticalRange = GGSizeRangeMake(CGRectGetMaxY(drawRect), CGRectGetMinY(drawRect));
            }
            
            if ([renderer isEqual:self.xTopAxisLable] ||
                [renderer isEqual:self.xBottomAxisLable]) {
                
                renderer.horizontalRange = GGSizeRangeMake(CGRectGetMaxX(drawRect), CGRectGetMinX(drawRect));
            }
        }
    }
}

/**
 * 判断格式化字符串是否为Int
 *
 * @param format 格式化字符串
 */
- (BOOL)formatIsInt:(NSString *)format
{
    return ([format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound
            || [format rangeOfString:@"%(.*)i"].location != NSNotFound);
}

/**
 * 获取Number轴格式化字符串
 *
 * @param numberAxis 轴数据格式
 * @param pixY Y轴数据
 */
- (NSString *)getStringWithNumberAxis:(id <NumberAxisAbstract>)numberAxis pixY:(CGFloat)pixY
{
    CGRect drawFrame = UIEdgeInsetsInsetRect(self.frame, [_queryDrawConfig insets]);
    
    pixY = pixY > CGRectGetMaxY(drawFrame) ? CGRectGetMaxY(drawFrame) : pixY;
    pixY = pixY < CGRectGetMinY(drawFrame) ? CGRectGetMinY(drawFrame) : pixY;
    
    CGFloat dataForPix = [numberAxis getNumberWithPix:pixY];
    NSString * dataFormat = [numberAxis dataFormatter];
    
    return [NSString stringWithFormat:dataFormat, [self formatIsInt:dataFormat] ? (int)dataForPix : dataForPix];
}

/**
 * 通过像素点获取轴向文字
 *
 * @param pix 像素点
 *
 * @return 转换像素点
 */
- (CGFloat)convertXAxisPix:(CGFloat)pixX
{
//    CGRect drawFrame = UIEdgeInsetsInsetRect(self.frame, [_queryDrawConfig insets]);
//    NSInteger splitCount = [[_queryDrawConfig lineBarArray].firstObject dataAry].count;
//    
//    CGFloat lineLength = drawFrame.size.width;
//    CGFloat splitWidth = lineLength / splitCount;
//    
//    NSInteger idx = (pixX - drawFrame.origin.x) / splitWidth;
//    idx = idx < splitCount ? idx : splitCount - 1;
//    idx = idx < 0 ? 0 : idx;
//
//    return [[_queryDrawConfig lineBarArray].firstObject points][idx].x;
    
    return pixX;
}

/**
 * 更新查价层
 *
 * touchPoint 显示中心点
 */
- (void)updateWithPoint:(CGPoint)touchPoint
{
    if ([_queryDrawConfig lineWidth] <= 0) return;
    
    CGRect drawFrame = UIEdgeInsetsInsetRect(self.frame, [_queryDrawConfig insets]);
    
    self.xLine.line = GGLineRectForX(drawFrame, [self convertXAxisPix:touchPoint.x]);
    self.yLine.line = GGLineRectForY(drawFrame, touchPoint.y);
    
    self.yLeftAxisLable.string = [self getStringWithNumberAxis:[_queryDrawConfig leftNumberAxis] pixY:touchPoint.y];
    self.yLeftAxisLable.point = self.yLine.line.start;
    
    self.yRightAxisLable.string = [self getStringWithNumberAxis:[_queryDrawConfig rightNumberAxis] pixY:touchPoint.y];
    self.yRightAxisLable.point = self.yLine.line.end;
    
    self.xTopAxisLable.string = [[_queryDrawConfig topLableAxis] getLablesPix:[self convertXAxisPix:touchPoint.x]];
    self.xTopAxisLable.point = self.xLine.line.start;
    
    self.xBottomAxisLable.string = [[_queryDrawConfig bottomLableAxis] getLablesPix:[self convertXAxisPix:touchPoint.x]];
    self.xBottomAxisLable.point = self.xLine.line.end;
    
    [self setNeedsDisplay];
}

#pragma mark - Lazy

GGLazyGetMethod(GGStringRenderer, xTopAxisLable);
GGLazyGetMethod(GGStringRenderer, yLeftAxisLable);
GGLazyGetMethod(GGStringRenderer, xBottomAxisLable);
GGLazyGetMethod(GGStringRenderer, yRightAxisLable);

GGLazyGetMethod(GGLineRenderer, xLine);
GGLazyGetMethod(GGLineRenderer, yLine);

@end
