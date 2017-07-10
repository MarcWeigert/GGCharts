//
//  KLineIndexManager.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KLineIndexManager.h"
#import "LuaContext.h"
#import "NSArray+Stock.h"

#define GGLazyLuaCodeMethod(fileName, attribute)               \
- (NSString *)attribute                                     \
{                                                           \
    if (!_##attribute) {                                    \
        _##attribute = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"lua"] \
                                                 encoding:NSUTF8StringEncoding \
                                                    error:nil]; \
        NSString * indexLibrary = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IndexLibrary" ofType:@"lua"] \
                                                    encoding:NSUTF8StringEncoding \
                                                       error:nil]; \
        _##attribute = [NSString stringWithFormat:@"%@ %@", indexLibrary, _##attribute]; \
    } \
    return _##attribute; \
}

@interface KLineIndexManager ()

@property (nonatomic, strong) NSString * luaMikeCode;   ///< MIKE
@property (nonatomic, strong) NSString * luaMaCode;     ///< MA
@property (nonatomic, strong) NSString * luaMacdCode;   ///< MACD
@property (nonatomic, strong) NSString * luaEmaCode;    ///< EMA
@property (nonatomic, strong) NSString * luaMavolCode;  ///< MAVOL

@end

@implementation KLineIndexManager

/** 单利指标类 */
+ (KLineIndexManager *)shareInstans
{
    static dispatch_once_t onceToken;
    static KLineIndexManager * indexManager;
    
    dispatch_once(&onceToken, ^{
        
        indexManager = [[KLineIndexManager alloc] init];
    });
    
    return indexManager;
}

/**
 * 根据数组数据结构计算EMA指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param MA 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 @[@{@"EMA5" : , @"EMA10" : , @"EMA20" : , @"EMA40" : }...]
 */
- (NSArray *)getEMAIndexWith:(NSArray <NSDictionary *> *)aryKLineData
                       param:(NSArray <NSNumber *> *)param
                 priceString:(NSString *)price
{
    LuaContext * luaContext = [LuaContext new];
    NSError * error = nil;
    
    if (![luaContext parse:self.luaEmaCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"EMAIndex" with:@[aryKLineData, price, param] error:&error];
}

/**
 * 根据数组数据结构计算EMA指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param MA 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 @[@{@"MA5" : , @"MA10" :, @"MA20" :, @"MA40" :}...]
 */
- (NSArray *)getMAIndexWith:(NSArray <NSDictionary *> *)aryKLineData
                      param:(NSArray <NSNumber *> *)param
                priceString:(NSString *)price
{
    LuaContext * luaContext = [LuaContext new];
    NSError * error = nil;
    
    if (![luaContext parse:self.luaMaCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"MAIndex" with:@[aryKLineData, price, param] error:&error];
}

/**
 * 根据数组数据结构计算MAVOL指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param MAVOL 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 @[@{@"MAVOL5" : , @"MAVOL10" :, @"MAVOL20" :, @"MAVOL40" :}...]
 */
- (NSArray *)getMAVOLIndexWith:(NSArray <NSDictionary *> *)aryKLineData
                         param:(NSArray <NSNumber *> *)param
                   priceString:(NSString *)price
{
    LuaContext * luaContext = [LuaContext new];
    NSError * error = nil;
    
    if (![luaContext parse:self.luaMavolCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"MAVOLIndex" with:@[aryKLineData, price, param] error:&error];
}

/**
 * 根据数组数据结构计算MACD指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param MACD 参数 {SHORT = 12, LONG = 26, M = 9}
 *
 * @return 计算结果 @[@{@"DIFF" : , @"DEA" :, @"STICK" : }...]
 */
- (NSArray *)getMACDIndexWith:(NSArray <NSDictionary *> *)aryKLineData
                        param:(NSDictionary *)param
                  priceString:(NSString *)price
{
    LuaContext * luaContext = [LuaContext new];
    NSError * error = nil;
    
    if (![luaContext parse:self.luaMacdCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"MACDIndex" with:@[aryKLineData, price, param] error:&error];
}

/**
 * 根据数组数据结构计算MIKE指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param 12
 *
 * @return 计算结果 @[@{@"wr" : , @"sr" :, @"ss" :, @"mr" :}...]
 */
- (NSArray *)getMikeIndexWith:(NSArray <id <KLineAbstract>> *)aryKLineData
                        param:(NSNumber *)param
              highPriceString:(NSString *)high
               lowPriceString:(NSString *)low
             closePriceString:(NSString *)close
{
    NSArray * kDataJson = [NSArray JsonFromObj:aryKLineData];
    LuaContext * luaContext = [LuaContext new];
    __block NSError * error = nil;
    
    if (![luaContext parse:self.luaMikeCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"MIKEIndex" with:@[kDataJson, high, low, close, param] error:&error];
}

#pragma mark - Lazy

GGLazyLuaCodeMethod(@"MIKE", luaMikeCode);
GGLazyLuaCodeMethod(@"EMA", luaEmaCode);
GGLazyLuaCodeMethod(@"MA", luaMaCode);
GGLazyLuaCodeMethod(@"MACD", luaMacdCode);
GGLazyLuaCodeMethod(@"MAVOL", luaMavolCode);

@end
