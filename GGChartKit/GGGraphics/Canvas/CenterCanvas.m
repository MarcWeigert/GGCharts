//
//  CenterCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "CenterCanvas.h"

@implementation CenterCanvas

- (void)drawChart
{
    [super drawChart];
    
    [self drawCircleAbstact];
}

- (void)drawCircleAbstact
{
    GGCircleRenderer * circleRenderer = [[GGCircleRenderer alloc] init];
    circleRenderer.circle = GGCirclePointMake([_centerConfig polygon].center, [_centerConfig polygon].radius);
    circleRenderer.fillColor = [_centerConfig fillColor];
    [self addRenderer:circleRenderer];
    
    // 文字
    GGNumberRenderer * numberRenderer = [[GGNumberRenderer alloc] init];
    numberRenderer.offSetRatio = [[_centerConfig lable] stringRatio];
    numberRenderer.toPoint = circleRenderer.circle.center;
    numberRenderer.toNumber = [[_centerConfig lable] number];
    numberRenderer.format = [[_centerConfig lable] stringFormat];
    numberRenderer.color = [[_centerConfig lable] lableColor];
    numberRenderer.font = [[_centerConfig lable] lableFont];
    numberRenderer.offSet = [[_centerConfig lable] stringOffSet];
    [numberRenderer drawAtToNumberAndPoint];
    numberRenderer.attrbuteStringValueBlock = [[_centerConfig lable] attrbuteStringValueBlock];
    [self addRenderer:numberRenderer];
    
    [self setNeedsDisplay];
}

@end
