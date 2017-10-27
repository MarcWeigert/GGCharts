//
//  BaseModel.m
//  HSCharts
//
//  Created by _ | Durex on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseModel.h"
#include <objc/runtime.h>

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    // NSLog(@"发现不匹配json: %@ -> %@", key, value);
}

/** 通过字典初始化数据 */
- (id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    
    if (self) {
        
        [self setValuesForKeysWithDictionary:dictionary];
    }
    
    return self;
}

/** 字典赋值数据 */
- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues
{
    if ([keyedValues isKindOfClass:[NSNull class]]) {
        return;
    }
    
    [BaseModel objectClass:[self class] keys:^(NSString *key) {
        
        // 属性负值
        if (keyedValues[key] != nil) {
            
            if ([keyedValues[key] isKindOfClass:[NSNull class]]) {
                
                ;
            }
            else {
                
                [self setValue:keyedValues[key] forKey:key];
            }
        }
    }];
    
    NSArray *bsKeys = [self keys];
    
    // 便利出与字典不匹配的key
    for (NSString *key in keyedValues.allKeys) {
        
        if (![bsKeys containsObject:key]) {
            
            [self setValue:keyedValues[key] forUndefinedKey:key];
        }
    }
}

/** 遍历模型键值对 */
+ (void)objectClass:(Class)baseSubClass keys:(void (^)(NSString *key))block
{
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList(baseSubClass, &count);
    
    for(int i = 0; i < count; i++)
    {
        objc_property_t property = properties[i];
        
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        
        block(key);
    }
    
    free(properties);
    
    // 判断父类是否是baseModel 如果是则递归到父类方法
    BaseModel *bs = [[BaseModel alloc] init];
    
    if (![bs isKindOfClass:[baseSubClass superclass]]) {
        
        [self objectClass:[baseSubClass superclass] keys:block];
    }
}

/** 对象json数据, 自雷类型, 返回多个对象 */
+ (NSArray *)arrayForArray:(NSArray *)array class:(Class)cls
{
    NSMutableArray *ary = [NSMutableArray array];
    
    if ([array isKindOfClass:[NSNull class]] ||
        array.count == 0 ||
        array == nil) return nil;
    
    for (NSDictionary *dic in array) {
        
        BaseModel *bs = [[cls alloc] init];
        
        [bs setValuesForKeysWithDictionary:dic];
        
        [ary addObject:bs];
    }
    
    return [NSArray arrayWithArray:ary];
}

/** 对象所有值 */
- (NSArray *)keys
{
    NSMutableArray *array = [NSMutableArray array];
    
    [BaseModel objectClass:[self class] keys:^(NSString *key) {
        
        [array addObject:key];
    }];
    
    return [NSArray arrayWithArray:array];
}

/** 对象转字典 */
- (NSDictionary *)dictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [BaseModel objectClass:[self class] keys:^(NSString *key) {
        
        id value = [self valueForKey:key];
        
        // 临时增加
        if (value == nil) return; // value = [NSNull class];
        
        [dictionary setObject:value forKey:key];
    }];
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

/** 输出对象 */
- (NSString *)description
{
    NSString *string = @"";
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i < outCount; i++) {
        
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        
        string = [string stringByAppendingString:[NSString stringWithFormat:@"%@: %@\n", propertyName, propertyValue]];
    }
    
    free(properties);
    
    return string;
}

/** debug输出对象 */
- (NSString *)debugDescription
{
    return [self description];
}

/** 转Json字符串 */
+ (NSString *)toJsonString:(id)object
{
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (! jsonData) {
        //NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

@end
