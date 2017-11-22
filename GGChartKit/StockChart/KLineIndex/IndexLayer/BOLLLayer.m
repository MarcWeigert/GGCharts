//
//  BOLLLayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BOLLLayer.h"

@interface BOLLLayer ()

@property (nonatomic, strong) NSDictionary *param;
@property (nonatomic, strong) NSArray <NSString *> *paramTitles;
@property (nonatomic, strong) NSDictionary <NSString *, UIColor *> *colorKeys;

@end

@implementation BOLLLayer

- (NSAttributedString *)attrStringWithIndex:(NSInteger)index
{
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@"BOLL(5)"];
    
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
    _param = @{@"SD" : @12, @"WIDTH" : @2};
    _paramTitles = @[@"m", @"t", @"b"];
    _colorKeys = @{@"m" : RGB(215, 161, 104), @"t" : RGB(115, 190, 222), @"b" : RGB(62, 121, 202)};
    
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    self.datas = [[KLineIndexManager shareInstans] getBOLLIndexWith:kDataJson
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
