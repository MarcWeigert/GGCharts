//
//  XAxis.m
//  GGCharts
//
//  Created by _ | Durex on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "XAxis.h"

@interface XAxis () <LableAxisAbstract>

@end

@implementation XAxis

/**
 * 通过像素点获取轴向文字
 *
 * @param pix 像素点
 *
 * @return 文字
 */
- (NSString *)getLablesPix:(CGFloat)pix
{
    NSInteger splitCount = [self lables].count;
    splitCount -= ![self drawStringAxisCenter];
    
    CGFloat lineLength = GGLengthLine(_axisLine);
    CGFloat splitWidth = lineLength / splitCount;
    
    NSInteger idx = (pix - _axisLine.start.x) / splitWidth;
    idx = idx < _lables.count ? idx : _lables.count - 1;
    idx = idx < 0 ? 0 : idx;
    
    return _lables[idx];
}

@end
