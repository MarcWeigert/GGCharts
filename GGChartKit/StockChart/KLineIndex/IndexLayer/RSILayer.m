//
//  RSILayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "RSILayer.h"

@interface RSILayer ()

@property (nonatomic, strong) NSArray <NSNumber *> *param;
@property (nonatomic, strong) NSArray <NSString *> *paramTitles;
@property (nonatomic, strong) NSDictionary <NSString *, UIColor *> *colorKeys;

@end

@implementation RSILayer

- (NSAttributedString *)attrStringWithIndex:(NSInteger)index
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@"RSI(6, 12, 24)"];
    
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
    _param = @[@6, @12, @24];
    _paramTitles = @[@"RSI6", @"RSI12", @"RSI24"];
    _colorKeys = @{@"RSI6" : RGB(215, 161, 104), @"RSI12" : RGB(115, 190, 222), @"RSI24" : RGB(62, 121, 202)};
    
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    self.datas = [[KLineIndexManager shareInstans] getRSIIndexWith:kDataJson
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
