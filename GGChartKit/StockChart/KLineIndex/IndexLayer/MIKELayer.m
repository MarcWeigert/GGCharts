//
//  MIKELayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "MIKELayer.h"

@interface MIKELayer ()

@property (nonatomic, strong) NSArray <NSNumber *> *param;
@property (nonatomic, strong) NSArray <NSString *> *paramTitles;
@property (nonatomic, strong) NSDictionary <NSString *, UIColor *> *colorKeys;

@end

@implementation MIKELayer

- (NSAttributedString *)attrStringWithIndex:(NSInteger)index
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@"MIKE(12)"];
    
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
    _param = @[@5, @10, @20, @40];
    _paramTitles = @[@"wr", @"mr", @"sr", @"ws", @"ms", @"ss"];
    _colorKeys = @{@"wr" : RGB(215, 161, 104),
                   @"mr" : RGB(115, 190, 222),
                   @"sr" : RGB(62, 121, 202),
                   @"ws" : RGB(110, 226, 121),
                   @"ms" : RGB(118, 251, 253),
                   @"ss" : RGB(128, 128, 128)};
    
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    self.datas = [[KLineIndexManager shareInstans] getMikeIndexWith:kDataJson
                                                              param:@12
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
