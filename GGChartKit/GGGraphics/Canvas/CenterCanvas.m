//
//  CenterCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "CenterCanvas.h"

@implementation CenterCanvas

- (void)drawChart
{
    [super drawChart];
    
    [self removeAllRenderer];
    [self drawCircleAbstact];
    [self drawCenterNumber];
    [self setNeedsDisplay];
}

- (void)drawCircleAbstact
{
    GGCircleRenderer * circleRenderer = [[GGCircleRenderer alloc] init];
    circleRenderer.circle = GGCirclePointMake([_centerConfig polygon].center, [_centerConfig polygon].radius);
    circleRenderer.fillColor = [_centerConfig fillColor];
    [self addRenderer:circleRenderer];
}

- (void)drawCenterNumber
{
    // 文字
    GGNumberRenderer * numberRenderer = [self getNumberRenderer];
    numberRenderer.offSetRatio = [[_centerConfig lable] stringRatio];
    numberRenderer.toPoint = [_centerConfig polygon].center;
    numberRenderer.toNumber = [[_centerConfig lable] number];
    numberRenderer.format = [[_centerConfig lable] stringFormat];
    numberRenderer.color = [[_centerConfig lable] lableColor];
    numberRenderer.font = [[_centerConfig lable] lableFont];
    numberRenderer.offSet = [[_centerConfig lable] stringOffSet];
    [numberRenderer drawAtToNumberAndPoint];
    numberRenderer.attrbuteStringValueBlock = [[_centerConfig lable] attrbuteStringValueBlock];
    [self addRenderer:numberRenderer];
}

@end
