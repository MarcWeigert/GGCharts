//
//  KLineData.m
//  GGCharts
//
//  Created by 黄舜 on 2017/10/27.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KLineData.h"
#import "NSDate+GGDate.h"

#define StockRedHexNumber           C_HEX(0xdd294d)
#define StockGreenHexNumber         C_HEX(0x21bc41)

/** 获取资金字符串 */
NSString *ctlString(CGFloat capital)
{
    NSString *str = @"";
    
    if (capital == 0) {
        
        str = @"--";
    }
    else if (capital > 10000 * 10000) {
        
        str = FLT_END_STR(capital / 10000, 0, @"亿");
    }
    else if (capital > 10000) {
        
        str = FLT_END_STR(capital / 10000, 2, @"亿");
    }
    else if (capital > 10000) {
        
        str = FLT_END_STR(capital, 0, @"万");
    }
    else {
        
        str = FLT_END_STR(capital, 2, @"万");
    }
    
    return str;
}

/** 获取成交量字符串 */
NSString *volString(NSInteger volume)
{
    NSString *str = @"";
    
    if (volume < 1000) {
        
        str = INT_STR_DML(volume, 2);
    }
    else if (volume >= 1000 && volume < 100000){
        
        str = FLT_END_STR(volume / 100.0, 2, @"手");
    }
    else if (volume >= 100000 && volume < (100.0 * 10000 * 10000)){
        
        str = FLT_END_STR(volume / (100.0 * 10000), 2, @"万手");
    }
    else if (volume >= (100.0 * 10000 * 10000)){
        
        str = FLT_END_STR(volume / (100.0 * 10000 * 10000), 2, @"亿手");
    }
    
    return str;
}

@interface KLineData ()

@property (nonatomic, strong) NSArray * valueForKeyArray;
@property (nonatomic, strong) NSDictionary * queryKeyForColor;
@property (nonatomic, strong) NSDictionary * queryValueForColor;

@end

@implementation KLineData

- (void)setDate:(NSString *)date
{
    _date = date;
    
    self.ggDate = [NSDate dateWithString:date format:@"yyyy-MM-dd HH:mm:ss"];
}

- (NSDate *)ggKLineDate
{
    return _ggDate;
}

- (CGFloat)ggOpen
{
    return _open_price;
}

- (CGFloat)ggClose
{
    return _close_price;
}

- (CGFloat)ggHigh
{
    return _high_price;
}

- (CGFloat)ggLow
{
    return _low_price;
}

- (CGFloat)ggVolume
{
    return _volume / 1000000;
}

- (NSDate *)ggVolumeDate
{
    return _ggDate;
}

- (UIColor *)colorForPrice:(CGFloat)price basePrice:(CGFloat)basePrice
{
    if (price > basePrice) {
        
        return StockRedHexNumber;
    }
    else if (price < basePrice) {
        
        return StockGreenHexNumber;
    }
    else {
        
        return [UIColor blackColor];
    }
}

- (UIColor *)colorForBase:(CGFloat)base
{
    if (base > 0) {
        
        return StockRedHexNumber;
    }
    else if (base < 0) {
        
        return StockGreenHexNumber;
    }
    else {
        
        return [UIColor blackColor];
    }
}

/**
 * 查询Value颜色
 *
 * @{@"key" : [UIColor redColor]}
 */
- (NSDictionary *)queryKeyForColor
{
    if (_queryKeyForColor == nil) {
        
        _queryKeyForColor = @{@"时间" : C_HEX(0xb6c5d3),
                              @"开盘" : C_HEX(0xb6c5d3),
                              @"收盘" : C_HEX(0xb6c5d3),
                              @"最高" : C_HEX(0xb6c5d3),
                              @"最低" : C_HEX(0xb6c5d3),
                              @"涨跌额" : C_HEX(0xb6c5d3),
                              @"涨跌幅" : C_HEX(0xb6c5d3),
                              @"成交量" : C_HEX(0xb6c5d3),
                              @"成交额" : C_HEX(0xb6c5d3),
                              @"换手率" : C_HEX(0xb6c5d3)};
    }
    
    return _queryKeyForColor;
}

/**
 * 查询Key颜色
 *
 * @{@"key" : [UIColor redColor]}
 */
- (NSDictionary *)queryValueForColor
{
    if (_queryValueForColor == nil) {
        
        CGFloat beforeClosePrice = _close_price;
        
        _queryValueForColor = @{[NSString stringWithFormat:@"%@", [_ggDate stringWithFormat:@"yyyy-MM-dd"]] : RGB(149, 149, 149),
                                [NSString stringWithFormat:@"%.2f", _open_price] : [self colorForPrice:_open_price basePrice:beforeClosePrice],
                                [NSString stringWithFormat:@"%.2f", _close_price] : [self colorForPrice:_close_price basePrice:beforeClosePrice],
                                [NSString stringWithFormat:@"%.2f", _high_price] : [self colorForPrice:_high_price basePrice:beforeClosePrice],
                                [NSString stringWithFormat:@"%.2f", _low_price] : [self colorForPrice:_low_price basePrice:beforeClosePrice],
                                [NSString stringWithFormat:@"%.2f", _price_change]: [self colorForBase:_price_change],
                                [NSString stringWithFormat:@"%.2f%%", _price_change_rate] : [self colorForBase:_price_change_rate],
                                [NSString stringWithFormat:@"%@", volString(_volume)] : RGB(149, 149, 149),
                                [NSString stringWithFormat:@"%@", ctlString(_turnover)] : RGB(149, 149, 149),
                                [NSString stringWithFormat:@"%.2f%%", _turnover_rate] : RGB(149, 149, 149)};
    }
    
    return _queryValueForColor;
}

/**
 * 键值对
 *
 * @[@{@"key" : @"value"},
 *   @{@"key" : @"value"},
 *   @{@"key" : @"value"}]
 */
- (NSArray <NSDictionary *> *)valueForKeyArray
{
    if (_valueForKeyArray == nil) {
        
        _valueForKeyArray = @[@{@"时间" : [NSString stringWithFormat:@"%@", [_ggDate stringWithFormat:@"yyyy-MM-dd"]]},
                              @{@"开盘" : [NSString stringWithFormat:@"%.2f", _open_price]},
                              @{@"收盘" : [NSString stringWithFormat:@"%.2f", _close_price]},
                              @{@"最高" : [NSString stringWithFormat:@"%.2f", _high_price]},
                              @{@"最低" : [NSString stringWithFormat:@"%.2f", _low_price]},
                              @{@"涨跌额" : [NSString stringWithFormat:@"%.2f", _price_change]},
                              @{@"涨跌幅" : [NSString stringWithFormat:@"%.2f%%", _price_change_rate]},
                              @{@"成交量" : [NSString stringWithFormat:@"%@", volString(_volume)]},
                              @{@"成交额" : [NSString stringWithFormat:@"%@", ctlString(_turnover)]},
                              @{@"换手率" : [NSString stringWithFormat:@"%.2f%%", _turnover_rate]}];
    }
    
    return _valueForKeyArray;
}

@end
