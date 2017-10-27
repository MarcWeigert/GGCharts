//
//  BaseModel.h
//  HSCharts
//
//  Created by _ | Durex on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject

/** 通过字典初始化数据 */
- (id)initWithDictionary:(NSDictionary *)dictionary;

/** 对象json数据, 自雷类型, 返回多个对象 */
+ (NSArray *)arrayForArray:(NSArray<NSDictionary *> *)array class:(Class)cls;

/** 对象转字典 */
- (NSDictionary *)dictionary;

/** 转Json字符串 */
+ (NSString *)toJsonString:(id)object;

@end
