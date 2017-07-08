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

#define GGLazyCodeMethod(fileName, attribute)               \
- (NSString *)attribute                                     \
{                                                           \
    if (!_##attribute) {                                    \
    _##attribute = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"lua"]    \
                                             encoding:NSUTF8StringEncoding                                              \
                                                error:nil];                                                             \
    }                                                                                                                   \
    return _##attribute;                                                                                                \
}

@interface KLineIndexManager ()

@property (nonatomic, strong) NSString * luaMaCode;     ///< MA

@property (nonatomic, strong) NSString * luaMikeCode;   ///< MIKE

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

/**
 * 根据数组数据结构计算MA指标数据
 *
 * @param aryKLineData K线数据数组, 需要实现接口KLineAbstract
 * @param param MA 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 @{@"MA5" : @[...], @"MA10" : @[...], @"MA20" : @[...], @"MA40" : @[...]};
 */
- (NSDictionary *)getMaIndexWith:(NSArray <id <KLineAbstract>> *)aryKLineData
                           param:(NSArray <NSNumber *> *)param
                     priceString:(NSString *)price
{
    NSArray * kDataJson = [NSArray JsonFromObj:aryKLineData];
    LuaContext * luaContext = [LuaContext new];
    __block NSError * error = nil;
    
    if (![luaContext parse:self.luaMaCode error:&error]) { NSLog(@"%@", error); }
    
    NSMutableDictionary * dictionaryMa = [NSMutableDictionary dictionary];
    
    [param enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        NSArray * aryIndex = [luaContext call:"MAIndex" with:@[kDataJson, @(kDataJson.count), price, obj] error:&error];
        
        [dictionaryMa setObject:aryIndex forKey:[NSString stringWithFormat:@"MA%@", obj]];
    }];
    
    return dictionaryMa;
}

/**
 * 根据数组数据结构计算MA指标数据
 *
 * @param aryKLineData 成交量数据数组, 需要实现接口VolumeAbstract
 * @param param MA 参数 @[@5, @10, @20, @40]
 *
 * @return 计算结果 @{@"MAVOL5" : @[...], @"MAVOL10" : @[...], @"MAVOL20" : @[...], @"MAVOL40" : @[...]};
 */
- (NSDictionary *)getVolumIndexWith:(NSArray <id <VolumeAbstract>> *)aryKLineData
                              param:(NSArray <NSNumber *> *)param
                        priceString:(NSString *)price
{
    NSArray * vDataJson = [NSArray JsonFrmVolums:aryKLineData];
    LuaContext * luaContext = [LuaContext new];
    __block NSError * error = nil;
    
    if (![luaContext parse:self.luaMaCode error:&error]) { NSLog(@"%@", error); }
    
    NSMutableDictionary * dictionaryMa = [NSMutableDictionary dictionary];
    
    [param enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
        
        NSArray * aryIndex = [luaContext call:"MAIndex" with:@[vDataJson, @(vDataJson.count), price, obj] error:&error];
        
        [dictionaryMa setObject:aryIndex forKey:[NSString stringWithFormat:@"MAVOL%@", obj]];
    }];
    
    return dictionaryMa;
}

#pragma mark - Lazy

GGLazyCodeMethod(@"MA", luaMaCode);

GGLazyCodeMethod(@"MIKE", luaMikeCode);

@end
