//
//  MACDLayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/10.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MACDLayer.h"

@interface MACDLayer ()

@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) NSArray <NSString *> *paramTitles;
@property (nonatomic, strong) NSDictionary <NSString *, UIColor *> *colorKeys;

@end

@implementation MACDLayer

- (NSArray <NSString *> *)titles
{
    return _paramTitles;
}

- (NSAttributedString *)attrStringWithIndex:(NSInteger)index
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@"MACD(5, 10, 20, 40)"];
    
    NSDictionary * dictionary = self.datas[index];
    
    [_paramTitles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        
        NSNumber * madata = dictionary[obj];
        UIColor * color = _colorKeys[obj];
        NSString * string = [NSString stringWithFormat:@"   %@:%.2f", obj, madata.floatValue];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : color}]];
    }];
    
    return attrString;
}

- (void)setKLineArray:(NSArray <id<KLineAbstract>> *)kLineArray
{
    _param = @{@"SHORT" : @12, @"LONG" : @26, @"M" : @9};
    _paramTitles = @[@"DIFF", @"DEA", @"STICK"];
    _colorKeys =  @{@"DIFF" : RGB(215, 161, 104), @"DEA" : RGB(115, 190, 222), @"STICK" : RGB(234, 82, 83)};
    
    NSArray * lineTitles = @[@"DIFF", @"DEA"];
    NSDictionary * lineColorKeys = @{@"DIFF" : RGB(215, 161, 104), @"DEA" : RGB(115, 190, 222)};
    
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    self.datas = [[KLineIndexManager shareInstans] getMACDIndexWith:kDataJson
                                                              param:_param
                                                        priceString:@"close"];
    
    [self registerLinesForDictionary:self.datas
                                keys:lineTitles
                        colorForKeys:lineColorKeys];
    
    [self registerBarsForDictionary:self.datas
                                key:@"STICK"
                      positiveColor:RGB(234, 82, 83)
                      negativeColor:RGB(77, 166, 73)];
}

/**
 * 绘制层数据
 */
- (void)updateLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min
{
    [self updateLineLayerWithRange:range max:max min:min];
    
    [self updateBarLayerWithRange:range max:max min:min];
}

@end
