//
//  ATRLayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "ATRLayer.h"

@interface ATRLayer ()

@property (nonatomic, strong) NSArray <NSNumber *> *param;
@property (nonatomic, strong) NSArray <NSString *> *paramTitles;
@property (nonatomic, strong) NSDictionary <NSString *, UIColor *> *colorKeys;

@end

@implementation ATRLayer

- (NSAttributedString *)attrStringWithIndex:(NSInteger)index
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@"ATR(24)"];
    
    NSDictionary * dictionary = self.datas[index];
    
    [_paramTitles enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        
        NSNumber * madata = dictionary[obj];
        UIColor * color = _colorKeys[obj];
        NSString * string = [NSString stringWithFormat:@"   %@:%.2f", obj.uppercaseString, madata.floatValue];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : color}]];
    }];
    
    return attrString;
}

- (void)setKLineArray:(NSArray <id<KLineAbstract>> *)kLineArray
{
    _paramTitles = @[@"tr", @"atr"];
    _colorKeys = @{@"tr" : RGB(215, 161, 104),
                   @"atr" : RGB(115, 190, 222)};
    
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    self.datas = [[KLineIndexManager shareInstans] getAtrIndexWith:kDataJson
                                                             param:@24
                                                   highPriceString:@"high"
                                                    lowPriceString:@"low"
                                                  closePriceString:@"close"];
    
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
