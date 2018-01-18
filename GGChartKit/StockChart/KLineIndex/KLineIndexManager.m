//
//  KLineIndexManager.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "KLineIndexManager.h"
#import "LuaContext.h"

#include        <stdio.h>
#include        "lua.h"
#include        "lualib.h"
#include        "lauxlib.h"

lua_State * L;


#define GGLazyLuaCodeMethod(fileName, attribute)               \
- (NSString *)attribute                                     \
{                                                           \
if (!_##attribute) {                                    \
_##attribute = [NSString stringWithContentsOfFile:[[NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"IndexLuaCode" withExtension:@"bundle"]] pathForResource:fileName ofType:@"lua"] \
encoding:NSUTF8StringEncoding \
error:nil]; \
NSString * indexLibrary = [NSString stringWithContentsOfFile:[[NSBundle bundleWithURL:[[NSBundle bundleForClass:[self class]] URLForResource:@"IndexLuaCode" withExtension:@"bundle"]] pathForResource:@"IndexLibrary" ofType:@"lua"] \
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
@property (nonatomic, strong) NSString * luaBbiCode;    ///< BBI
@property (nonatomic, strong) NSString * luaBollCode;    ///< BOLL
@property (nonatomic, strong) NSString * luaKdjCode;     ///< KDJ
@property (nonatomic, strong) NSString * luaRsiCode;     ///< RSI
@property (nonatomic, strong) NSString * luaAtrCode;     ///< Atr
@property (nonatomic, strong) NSString * luaTdCode;     ///< TD

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
 * 根据数组数据结构计算BBI指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param BBI 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 计算结果 @[@{@"bbi" : xxx}...]
 */
- (NSArray *)getBBIIndexWith:(NSArray <NSDictionary *> *)aryKLineData
                       param:(NSArray <NSNumber *> *)param
                 priceString:(NSString *)price
{
    LuaContext * luaContext = [LuaContext new];
    NSError * error = nil;
    
    if (![luaContext parse:self.luaBbiCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"BBIIndex" with:@[aryKLineData, price, param] error:&error];
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
- (NSArray *)getMikeIndexWith:(NSArray <NSDictionary *> *)aryKLineData
                        param:(NSNumber *)param
              highPriceString:(NSString *)high
               lowPriceString:(NSString *)low
             closePriceString:(NSString *)close
{
    LuaContext * luaContext = [LuaContext new];
    __block NSError * error = nil;
    
    if (![luaContext parse:self.luaMikeCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"MIKEIndex" with:@[aryKLineData, high, low, close, param] error:&error];
}

/**
 * 根据数组数据结构计算BBI指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param BOLL 参数 12
 *
 * @return 计算结果 @[@{@"m" : xxx, @"t" : xxx, @"b" : xxx}...]
 */
- (NSArray *)getBOLLIndexWith:(NSArray <NSDictionary *> *)aryKLineData
                        param:(NSDictionary *)param
                  priceString:(NSString *)price
{
    LuaContext * luaContext = [LuaContext new];
    __block NSError * error = nil;
    
    if (![luaContext parse:self.luaBollCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"BOLLIndex" with:@[aryKLineData, price, param] error:&error];
}

/**
 * 根据数组数据结构计算KDJ指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param BOLL 参数 12
 *
 * @return 计算结果 @[@{@"n" : xxx, @"m1" : xxx, @"m2" : xxx}...]
 */
- (NSArray *)getKDJIndexWith:(NSArray <id <KLineAbstract>> *)aryKLineData
                       param:(NSDictionary *)param
             highPriceString:(NSString *)high
              lowPriceString:(NSString *)low
            closePriceString:(NSString *)close
{
    LuaContext * luaContext = [LuaContext new];
    __block NSError * error = nil;
    
    if (![luaContext parse:self.luaKdjCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"KDJIndex" with:@[aryKLineData, low, high, close, param] error:&error];
}

/**
 * 根据数组数据结构计算MA指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param RSI 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 @[@{@"RSI5" : , @"RSI10" :, @"RSI20" :, @"RSI40" :}...]
 */
- (NSArray *)getRSIIndexWith:(NSArray <NSDictionary *> *)aryKLineData
                       param:(NSArray <NSNumber *> *)param
                 priceString:(NSString *)price
{
    LuaContext * luaContext = [LuaContext new];
    NSError * error = nil;
    
    if (![luaContext parse:self.luaRsiCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"RSIIndex" with:@[aryKLineData, price, param] error:&error];
}

/**
 * 根据数组数据结构计算MIKE指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param 12
 *
 * @return 计算结果 @[@{@"ar" : , @"atr" :}...]
 */
- (NSArray *)getAtrIndexWith:(NSArray <id <KLineAbstract>> *)aryKLineData
                       param:(NSNumber *)param
             highPriceString:(NSString *)high
              lowPriceString:(NSString *)low
            closePriceString:(NSString *)close
{
    LuaContext * luaContext = [LuaContext new];
    __block NSError * error = nil;
    
    if (![luaContext parse:self.luaAtrCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"ATRIndex" with:@[aryKLineData, low, high, close, param] error:&error];
}

/**
 * 根据数组数据结构计算TD指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param 12
 *
 * @return 计算结果 @[@{@"ar" : , @"atr" :}...]
 */
- (NSArray *)getTDIndexWith:(NSArray <id <KLineAbstract>> *)aryKLineData
                      param:(NSNumber *)param
            highPriceString:(NSString *)high
             lowPriceString:(NSString *)low
           closePriceString:(NSString *)close
{
    LuaContext * luaContext = [LuaContext new];
    __block NSError * error = nil;
    
    if (![luaContext parse:self.luaTdCode error:&error]) { NSLog(@"%@", error); }
    
    return [luaContext call:"TDIndex" with:@[aryKLineData, low, close, high, param] error:&error];
}

#pragma mark - Lazy

GGLazyLuaCodeMethod(@"MIKE", luaMikeCode);
GGLazyLuaCodeMethod(@"EMA", luaEmaCode);
GGLazyLuaCodeMethod(@"MA", luaMaCode);
GGLazyLuaCodeMethod(@"MACD", luaMacdCode);
GGLazyLuaCodeMethod(@"MAVOL", luaMavolCode);
GGLazyLuaCodeMethod(@"BBI", luaBbiCode);
GGLazyLuaCodeMethod(@"BOLL", luaBollCode);
GGLazyLuaCodeMethod(@"KDJ", luaKdjCode);
GGLazyLuaCodeMethod(@"RSI", luaRsiCode);
GGLazyLuaCodeMethod(@"ATR", luaAtrCode);
GGLazyLuaCodeMethod(@"TD", luaTdCode);

@end
