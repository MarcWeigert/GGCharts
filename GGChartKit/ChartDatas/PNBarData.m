//
//  PNBarData.m
//  HSCharts
//
//  Created by _ | Durex on 2017/6/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PNBarData.h"
#import "CGPathCategory.h"
#import "GGChartDefine.h"

#define POS_C               RGB(241, 73, 81)
#define NEG_C               RGB(30, 191, 97)

@implementation PNBarData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _positiveColor = POS_C;
        _negativeColor = NEG_C;
    }
    
    return self;
}

#pragma mark - Public

/**
 * 绘制柱状图层
 *
 * @param pBarCanvas 正数柱图层
 * @param nBarCanvas 负数柱图层
 */
- (void)drawPNBarWithCanvas:(GGShapeCanvas *)pBarCanvas negativeCanvas:(GGShapeCanvas *)nBarCanvas
{
    _pBarCanvas = pBarCanvas;
    _nBarCanvas = nBarCanvas;
    
    self.barScaler.bottomPrice = 0;
    [self.barScaler updateScaler];
    
    // 正数柱图层
    CGMutablePathRef ref_p = CGPathCreateMutable();
    [self.barScaler getPositiveData:^(CGRect *rects, size_t size) {
        
        GGpathAddCGRects(ref_p, rects, size);
    }];
    self.pBarCanvas.path = ref_p;
    self.pBarCanvas.fillColor = _positiveColor.CGColor;
    self.pBarCanvas.lineWidth = 0;
    CGPathRelease(ref_p);
    
    // 负数柱图层
    CGMutablePathRef ref_n = CGPathCreateMutable();
    [self.barScaler getNegativeData:^(CGRect *rects, size_t size) {
        
        GGpathAddCGRects(ref_n, rects, size);
    }];
    self.nBarCanvas.path = ref_n;
    self.nBarCanvas.fillColor = _negativeColor.CGColor;
    self.nBarCanvas.lineWidth = 0;
    CGPathRelease(ref_n);
}

#pragma mark - Getter

- (void)setNegativeColor:(UIColor *)negativeColor
{
    _negativeColor = negativeColor;
    _nBarCanvas.fillColor = negativeColor.CGColor;
}

- (void)setPositiveColor:(UIColor *)positiveColor
{
    _positiveColor = positiveColor;
    _pBarCanvas.fillColor = positiveColor.CGColor;
}

@end
