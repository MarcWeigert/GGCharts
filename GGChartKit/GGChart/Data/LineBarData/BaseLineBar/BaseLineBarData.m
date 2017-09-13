//
//  BaseLineBarData.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseLineBarData.h"

@interface BaseLineBarData ()


@end

@implementation BaseLineBarData

/**
 * 围绕该Y轴坐标点填充, FLT_MIN 代表不填充
 */
- (CGFloat)bottomYPix
{
    if (self.roundNumber == nil) {      // 如果没有底部定标, 则取最低值
        
        return CGRectGetMaxY(self.lineBarScaler.rect);
    }
    
    return [self.lineBarScaler getYPixelWithData:self.roundNumber.floatValue];
}

/**
 * 设置环绕数据
 */
- (void)setRoundNumber:(NSNumber *)roundNumber
{
    _roundNumber = roundNumber;
    
    self.lineBarScaler.aroundNumber = roundNumber;
}

@end
