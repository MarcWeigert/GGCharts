//
//  MALayer.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MALayer.h"
#import "DLineScaler.h"
#import "GGChartDefine.h"
#import "KLineIndexManager.h"
#import "GGGraphics.h"

@interface MALayer ()

@property (nonatomic, strong) NSArray <NSNumber *> *param;
@property (nonatomic, strong) NSArray <NSString *> *paramTitles;
@property (nonatomic, strong) NSDictionary <NSString *, UIColor *> *colorKeys;

@end

@implementation MALayer

- (NSArray <NSString *> *)titles
{
    return _paramTitles;
}

- (void)setKLineArray:(NSArray <id<KLineAbstract>> *)kLineArray
{
    _param = @[@5, @10, @20, @40];
    _paramTitles = @[@"MA5", @"MA10", @"MA20", @"MA40"];
    _colorKeys = @{@"MA5" : RGB(215, 161, 104), @"MA10" : RGB(115, 190, 222), @"MA20" : RGB(62, 121, 202), @"MA40" : RGB(110, 226, 121)};
    
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    self.datas = [[KLineIndexManager shareInstans] getMAIndexWith:kDataJson
                                                            param:_param
                                                      priceString:@"close"];
    
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