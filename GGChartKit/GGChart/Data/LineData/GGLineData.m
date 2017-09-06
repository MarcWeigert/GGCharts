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

- (DLineScaler *)lineScaler
{
    if (_lineScaler == nil) {
        
        _lineScaler = [[DLineScaler alloc] init];
    }
    
    return _lineScaler;
}

- (void)setLineDataAry:(NSArray<NSNumber *> *)lineDataAry
{
    _lineDataAry = lineDataAry;
    self.lineScaler.dataAry = lineDataAry;
}

@end
