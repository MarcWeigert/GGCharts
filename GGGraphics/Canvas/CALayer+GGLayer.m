//
//  CALayer+GGLayer.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "CALayer+GGLayer.h"

@implementation CALayer (GGLayer)

- (void)bringSublayerToFront:(CALayer *)layer
{
    [layer removeFromSuperlayer];
    [self insertSublayer:layer atIndex:(unsigned)[self.sublayers count]];
}

- (void)sendSublayerToBack:(CALayer *)layer
{
    [layer removeFromSuperlayer];
    [self insertSublayer:layer atIndex:0];
}

@end
