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

#include        <stdio.h>
#include        "lua.h"
#include        "lualib.h"
#include        "lauxlib.h"

lua_State * L;


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

const char * convertToJSONData(id infoDict)
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:infoDict
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    
    NSString *jsonString = @"";
    
    if (! jsonData)
    {
        NSLog(@"Got an error: %@", error);
    }else
    {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
    [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    return [jsonString cStringUsingEncoding:NSUTF8StringEncoding];
}

NSString * luaadd(NSArray <NSDictionary *> * arrayList, NSString * getMethod, id param, NSString * script)
{
    /*the function name*/
    
    L = luaL_newstate();
    
    luaL_dostring(L, [script UTF8String]);
    
    lua_getglobal(L, "BOLLIndex");
    
    /*the first argument*/
    
    lua_pushstring(L, convertToJSONData(arrayList));
    lua_pushstring(L, [getMethod cStringUsingEncoding:NSUTF8StringEncoding]);
    lua_pushstring(L, [[param stringValue] cStringUsingEncoding:NSUTF8StringEncoding]);
    
    /*call the function with 2 arguments,return 1 result.*/
    
    lua_pcall(L, 3, 1, 0);
    
    /*g et the result.*/
    
    const char * sum = lua_tolstring(L, -1, nil);
    
    /*cleanup the return*/
    lua_pop(L, 1);
    
    return nil;
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
                        param:(NSNumber *)param
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

@end
