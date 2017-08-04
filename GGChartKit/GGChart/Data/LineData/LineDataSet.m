//
//  LineDataSet.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineDataSet.h"

@interface LineDataSet () <LineCanvasAbstract>

@end

@implementation LineDataSet

- (UIEdgeInsets)lineInsets
{
    return _gridInside;
}

@end
