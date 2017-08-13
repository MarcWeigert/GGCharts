//
//  GGRectRenderer.m
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGRectRenderer.h"

@implementation GGRectRenderer

- (void)drawInContext:(CGContextRef)ctx
{
    if (_fillColor) {
        
        CGContextFillRect(ctx, _rect);
    }
}

@end
