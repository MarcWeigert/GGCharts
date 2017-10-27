//
//  KDJLayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KDJLayer.h"

@interface KDJLayer ()

@property (nonatomic, strong) NSArray <NSNumber *> *param;
@property (nonatomic, strong) NSArray <NSString *> *paramTitles;
@property (nonatomic, strong) NSDictionary <NSString *, UIColor *> *colorKeys;

@end

@implementation KDJLayer

- (NSAttributedString *)attrStringWithIndex:(NSInteger)index
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@"KDJ(6, 12, 24)"];
    
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
    _paramTitles = @[@"k", @"d", @"j"];
    _colorKeys = @{@"k" : RGB(215, 161, 104),
                   @"d" : RGB(115, 190, 222),
                   @"j" : RGB(62, 121, 202)};
    
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    self.datas = [[KLineIndexManager shareInstans] getKDJIndexWith:kDataJson
                                                             param:@{@"n" : @6, @"m1" : @12, @"m2" : @24}
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
