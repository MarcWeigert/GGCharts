//
//  GridBackCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
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
            renderer.showSep = [abstract over] > 0;
            renderer.textOffSet = CGSizeMake([abstract stringGap], 0);
            renderer.offSetRatio = [abstract offSetRatio];
            
            [self addRenderer:renderer];
        }
    }
}

/**
 * 配置Number轴
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
            renderer.showSep = [abstract over] > 0;
            renderer.textOffSet = CGSizeMake(0, [abstract stringGap]);
            renderer.offSetRatio = [abstract offSetRatio];
            renderer.drawAxisCenter = [abstract drawStringAxisCenter];
            renderer.hiddenPattern = [abstract hiddenPattern];
            
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
    CGFloat splitLength = lineLength / ([numberAxisAbstract splitCount] + 1);
    
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
    [self setNeedsDisplay];
}

#pragma mark - Lazy

/**
 * 左轴渲染器
 */
- (GGAxisRenderer *)leftAxisRenderer
{
    if (_leftAxisRenderer == nil) {
        
        _leftAxisRenderer = [[GGAxisRenderer alloc] init];
    }
    
    return _leftAxisRenderer;
}

/**
 * 右轴渲染器
 */
- (GGAxisRenderer *)rightAxisRenderer
{
    if (_rightAxisRenderer == nil) {
        
        _rightAxisRenderer = [[GGAxisRenderer alloc] init];
    }
    
    return _rightAxisRenderer;
}

/**
 * 顶轴渲染器
 */
- (GGAxisRenderer *)topAxisRenderer
{
    if (_topAxisRenderer == nil) {
        
        _topAxisRenderer = [[GGAxisRenderer alloc] init];
    }
    
    return _topAxisRenderer;
}

/**
 * 底轴渲染器
 */
- (GGAxisRenderer *)bottomAxisRenderer
{
    if (_bottomAxisRenderer == nil) {
        
        _bottomAxisRenderer = [[GGAxisRenderer alloc] init];
    }
    
    return _bottomAxisRenderer;
}

@end
