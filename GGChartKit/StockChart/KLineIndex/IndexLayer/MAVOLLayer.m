//
//  MAVOLLayer.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MAVOLLayer.h"
#import "DLineScaler.h"
#import "GGChartDefine.h"
#import "KLineIndexManager.h"
#import "GGGraphics.h"

@interface MAVOLLayer ()

@property (nonatomic, strong) NSArray <NSNumber *> *param;
@property (nonatomic, strong) NSArray <NSString *> *paramTitles;
@property (nonatomic, strong) NSDictionary <NSString *, UIColor *> *colorKeys;

@end

@implementation MAVOLLayer

- (NSArray <NSString *> *)titles
{
    return _paramTitles;
}

- (void)setKLineArray:(NSArray <id<KLineAbstract, VolumeAbstract>> *)kLineArray
{
    _param = @[@5, @10, @20, @40];
    _paramTitles = @[@"MAVOL5", @"MAVOL10", @"MAVOL20", @"MAVOL40"];
    _colorKeys = @{@"MAVOL5" : RGB(215, 161, 104), @"MAVOL10" : RGB(115, 190, 222), @"MAVOL20" : RGB(62, 121, 202), @"MAVOL40" : RGB(110, 226, 121)};
    
    NSArray * kDataJson = [NSArray JsonFrmVolums:kLineArray];
    
    self.datas = [[KLineIndexManager shareInstans] getMAVOLIndexWith:kDataJson
                                                               param:_param
                                                         priceString:@"volum"];
    
    [self registerLinesForDictionary:self.datas keys:_paramTitles colorForKeys:_colorKeys];
}

/**
 * 绘制层数据
 */
- (void)updateLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min
{
    [self updateLineLayerWithRange:range max:max min:min];
}

@end
