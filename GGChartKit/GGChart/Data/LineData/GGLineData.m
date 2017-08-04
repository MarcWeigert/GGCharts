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

@property (nonatomic, strong) DLineScaler * myLineScaler;

@end

@implementation GGLineData

- (void)setLineDataAry:(NSArray<NSNumber *> *)lineDataAry
{
    _lineDataAry = lineDataAry;
    
    _myLineScaler = [DLineScaler new];
    _myLineScaler.dataAry = lineDataAry;
}

- (DLineScaler *)lineScaler
{
    return _myLineScaler;
}

@end
