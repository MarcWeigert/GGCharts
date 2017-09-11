//
//  GGLineData.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGLineData.h"
#import "LineDrawAbstract.h"

@interface GGLineData () <LineDrawAbstract>
{
    DLineScaler * _lineScaler;
}

@end

@implementation GGLineData

/**
 * 折线定标器
 */
- (DLineScaler *)lineScaler
{
    if (_lineScaler == nil) {
        
        _lineScaler = [[DLineScaler alloc] init];
    }
    
    return _lineScaler;
}

/**
 * 用来显示的数据
 */
- (void)setDataAry:(NSArray<NSNumber *> *)dataAry
{
    _dataAry = dataAry;
    self.lineScaler.dataAry = dataAry;
}

/**
 * 绘制折线点
 */
- (CGPoint *)points
{
    return _lineScaler.linePoints;
}

/**
 * 围绕该Y轴坐标点填充, FLT_MIN 代表不填充
 */
- (CGFloat)bottomYPix
{
    if (_fillRoundNumber == nil) {      // 如果没有底部定标, 则取最低值
        
        return CGRectGetMaxY(_lineScaler.rect);
    }
    
    return [_lineScaler getYPixelWithData:_fillRoundNumber.floatValue];
}

@end
