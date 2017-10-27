//
//  GridBackCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GridBackCanvas.h"

@interface GridBackCanvas ()

/**
 * 左轴渲染器
 */
@property (nonatomic, strong) GGAxisRenderer * leftAxisRenderer;

/**
 * 右轴渲染器
 */
@property (nonatomic, strong) GGAxisRenderer * rightAxisRenderer;

/**
 * 顶轴渲染器
 */
@property (nonatomic, strong) GGAxisRenderer * topAxisRenderer;

/**
 * 底轴渲染器
 */
@property (nonatomic, strong) GGAxisRenderer * bottomAxisRenderer;

/**
 * 左轴标题
 */
@property (nonatomic, strong) GGStringRenderer * leftAxisName;

/**
 * 右轴标题
 */
@property (nonatomic, strong) GGStringRenderer * rightAxisName;

@end

@implementation GridBackCanvas

/** 
 * 配置Number轴 
 */
- (void)configNumberAxis
{
    NSArray * axisRenderers = @[self.leftAxisRenderer, self.rightAxisRenderer];
    NSArray * axisAbstracts = @[[_gridDrawConfig leftNumberAxis], [_gridDrawConfig rightNumberAxis]];
    
    for (NSInteger i = 0; i < axisRenderers.count; i++) {
        
        GGAxisRenderer * renderer = axisRenderers[i];
        id <NumberAxisAbstract> abstract = axisAbstracts[i];
        
        if ([abstract splitCount] > 0) {        // 分割个数大于0则配置
            
            // 构建轴结构
            CGFloat length =  GGLengthLine([abstract axisLine]);
            CGFloat splitLength = length / [abstract splitCount];
            GGAxis axis = GGAxisLineMake([abstract axisLine], [abstract over], splitLength);
            
            // 取轴文字数据
            BOOL isInt = [self formatIsInt:[abstract dataFormatter]];
            NSArray * titles = [self numbersTitlesForAxis:abstract isIntFormat:isInt];
            
            renderer.aryString = titles;
            renderer.axis = axis;
            renderer.width = [_gridDrawConfig lineWidth];
            renderer.color = [_gridDrawConfig axisLineColor];
            renderer.strColor = [_gridDrawConfig axisLableColor];
            renderer.showSep = [abstract over] != 0;
            renderer.textOffSet = CGSizeMake([abstract stringGap], 0);
            renderer.offSetRatio = [abstract offSetRatio];
            renderer.showLine = NO;
            renderer.strFont = [_gridDrawConfig axisLableFont];
            
            [self addRenderer:renderer];
        }
    }
}

/**
 * 配置Lable轴
 */
- (void)configLableAxis
{
    NSArray * axisRenderers = @[self.topAxisRenderer, self.bottomAxisRenderer];
    NSArray * axisAbstracts = @[[_gridDrawConfig topLableAxis], [_gridDrawConfig bottomLableAxis]];
    
    for (NSInteger i = 0; i < axisRenderers.count; i++) {
        
        GGAxisRenderer * renderer = axisRenderers[i];
        id <LableAxisAbstract> abstract = axisAbstracts[i];
        
        if ([abstract lables].count > 0) {      // 轴文字数组个数大于0则绘制
            
            if ([abstract showIndexSet].count > 0) {    // 文字选择性显示
                
                GGLine line = [abstract axisLine];
                CGFloat splitWidth = GGLengthLine(line) / ([abstract lables].count - 1);
                renderer.axis = GGAxisLineMake(line, [abstract over], 0);
                
                [[abstract showIndexSet] enumerateObjectsUsingBlock:^(NSNumber * obj, BOOL * _Nonnull stop) {
                    
                    CGPoint point = CGPointMake(splitWidth * obj.integerValue, renderer.axis.line.start.y);
                    [renderer addString:[abstract lables][obj.integerValue] point:point];
                }];
            }
            else {      // 文字全部绘制
                
                NSInteger splitCount = [abstract lables].count;
                splitCount -= ![abstract drawStringAxisCenter];
                CGFloat length =  GGLengthLine([abstract axisLine]);
                GGAxis axis = GGAxisLineMake([abstract axisLine], [abstract over], length / splitCount);
                
                renderer.aryString = [abstract lables];
                renderer.axis = axis;
            }
            
            renderer.width = [_gridDrawConfig lineWidth];
            renderer.color = [_gridDrawConfig axisLineColor];
            renderer.strColor = [_gridDrawConfig axisLableColor];
            renderer.strFont = [_gridDrawConfig axisLableFont];
            renderer.showSep = [abstract over] != 0;
            renderer.textOffSet = CGSizeMake(0, [abstract stringGap]);
            renderer.offSetRatio = [abstract offSetRatio];
            renderer.drawAxisCenter = [abstract drawStringAxisCenter];
            renderer.hiddenPattern = [abstract hiddenPattern];
            renderer.showLine = NO;
            
            [self addRenderer:renderer];
        }
    }
}

/**
 * 配置网格线
 */
- (void)configSplitGridLine
{
    NSArray * numberAbstracts = @[[_gridDrawConfig rightNumberAxis], [_gridDrawConfig leftNumberAxis]];
    NSArray * lableAbstracts = @[[_gridDrawConfig topLableAxis], [_gridDrawConfig bottomLableAxis]];
    
    CGRect gridRect = UIEdgeInsetsInsetRect(self.frame, _gridDrawConfig.insets);
    
    for (id <NumberAxisAbstract> numberAxis in numberAbstracts) {
        
        if (![numberAxis showSplitLine]) continue;
        
        GGLine line = [numberAxis axisLine];
        CGFloat lineLength = GGLengthLine(line);
        CGFloat splitLength = lineLength / [numberAxis splitCount];
        
        for (NSInteger i = 0; i <= [numberAxis splitCount]; i++) {
            
            GGLineRenderer * lineRenderer = [[GGLineRenderer alloc] init];
            lineRenderer.line = GGLineRectForY(gridRect, line.start.y + splitLength * i);
            lineRenderer.color = [_gridDrawConfig lineColor];
            lineRenderer.width = [_gridDrawConfig lineWidth];
            lineRenderer.dashPattern = [_gridDrawConfig dashPattern];
            [self addRenderer:lineRenderer];
        }
    }
    
    for (id <LableAxisAbstract> lableAxis in lableAbstracts) {
        
        if (![lableAxis showSplitLine]) continue;
        
        if ([lableAxis showIndexSet].count > 0) {    // 文字选择性显示
            
            GGLine line = [lableAxis axisLine];
            CGFloat splitWidth = GGLengthLine(line) / ([lableAxis lables].count - 1);
            
            [[lableAxis showIndexSet] enumerateObjectsUsingBlock:^(NSNumber * obj, BOOL * _Nonnull stop) {
                
                CGPoint start = CGPointMake(splitWidth * obj.integerValue + gridRect.origin.x, CGRectGetMinY(gridRect));
                CGPoint end = CGPointMake(splitWidth * obj.integerValue + gridRect.origin.x, CGRectGetMaxY(gridRect));
                
                GGLineRenderer * lineRenderer = [[GGLineRenderer alloc] init];
                lineRenderer.line = GGPointLineMake(start, end);
                lineRenderer.color = [_gridDrawConfig lineColor];
                lineRenderer.width = [_gridDrawConfig lineWidth];
                lineRenderer.dashPattern = [_gridDrawConfig dashPattern];
                [self addRenderer:lineRenderer];
            }];
            
            CGPoint start = CGPointMake(GGLengthLine(line) + gridRect.origin.x, CGRectGetMinY(gridRect));
            CGPoint end = CGPointMake(GGLengthLine(line) + gridRect.origin.x, CGRectGetMaxY(gridRect));
            
            GGLineRenderer * lineRenderer = [[GGLineRenderer alloc] init];
            lineRenderer.line = GGPointLineMake(start, end);
            lineRenderer.color = [_gridDrawConfig lineColor];
            lineRenderer.width = [_gridDrawConfig lineWidth];
            lineRenderer.dashPattern = [_gridDrawConfig dashPattern];
            [self addRenderer:lineRenderer];
        }
        else {
        
            NSInteger splitCount = [lableAxis lables].count;
            splitCount -= ![lableAxis drawStringAxisCenter];
            CGFloat length = GGLengthLine([lableAxis axisLine]);
            CGFloat splitLength = length / splitCount;
            
            for (NSInteger i = 0; i <= splitCount; i++) {
                
                GGLineRenderer * lineRenderer = [[GGLineRenderer alloc] init];
                lineRenderer.line = GGLineRectForX(gridRect, [lableAxis axisLine].start.x + splitLength * i);
                lineRenderer.color = [_gridDrawConfig lineColor];
                lineRenderer.width = [_gridDrawConfig lineWidth];
                lineRenderer.dashPattern = [_gridDrawConfig dashPattern];
                [self addRenderer:lineRenderer];
            }
        }
    }
}

/**
 * 设置轴标题
 */
- (void)configNumberAxisName
{
    NSArray * axisNames = @[[[_gridDrawConfig leftNumberAxis] name], [[_gridDrawConfig rightNumberAxis] name]];
    NSArray * titleRenderers = @[self.leftAxisName, self.rightAxisName];
    NSArray * axisRenderers = @[self.leftAxisRenderer, self.rightAxisRenderer];
    
    for (NSInteger i = 0; i < axisNames.count; i++) {
        
        id <NumberAxisNameAbstract> axisName = axisNames[i];
        GGStringRenderer * renderer = titleRenderers[i];
        GGAxisRenderer * axisRenderer = axisRenderers[i];
        
        if ([axisName string].length > 0) {
            
            renderer.string = [axisName string];
            renderer.font = [axisName font];
            renderer.color = [axisName color];
            renderer.offSetRatio = [axisName offSetRatio];
            renderer.offset = [axisName offSetSize];
            renderer.point = axisRenderer.axis.line.start;
            
            [self addRenderer:renderer];
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
 * 获取Number文字数据
 *
 * @param numberAxisAbstract 数字轴接口
 * @param isIntFormat 是否带有int格式化字符串
 *
 * @return 转换文字数据
 */
- (NSArray <NSString *> *)numbersTitlesForAxis:(id <NumberAxisAbstract>)numberAxisAbstract isIntFormat:(BOOL)isIntFormat
{
    NSMutableArray * aryStrings = [NSMutableArray array];
    
    GGLine line = [numberAxisAbstract axisLine];
    CGFloat lineLength = GGLengthLine(line);
    CGFloat splitLength = lineLength / [numberAxisAbstract splitCount];
    
    for (NSInteger i = 0; i < [numberAxisAbstract splitCount] + 1; i++) {
        
        CGFloat dataForPix = [numberAxisAbstract getNumberWithPix:splitLength * i + line.start.y];
        [aryStrings addObject:[NSString stringWithFormat:[numberAxisAbstract dataFormatter], isIntFormat ? (int)dataForPix : dataForPix]];
    }
    
    return aryStrings;
}

#pragma mark - 父类方法

/**
 * 渲染图层
 */
- (void)drawChart
{
    [self removeAllRenderer];
    
    [self configNumberAxis];
    [self configLableAxis];
    [self configSplitGridLine];
    [self configNumberAxisName];
    
    [self setNeedsDisplay];
}

#pragma mark - Lazy

GGLazyGetMethod(GGAxisRenderer, rightAxisRenderer);
GGLazyGetMethod(GGAxisRenderer, leftAxisRenderer);
GGLazyGetMethod(GGAxisRenderer, topAxisRenderer);
GGLazyGetMethod(GGAxisRenderer, bottomAxisRenderer);

GGLazyGetMethod(GGStringRenderer, rightAxisName);
GGLazyGetMethod(GGStringRenderer, leftAxisName);

@end
