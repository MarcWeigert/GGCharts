//
//  GGRuntimeHelper.h
//  GGCharts
//
//  Created by 黄舜 on 2017/11/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

/**
 * float返回值Get方法
 */
typedef float(* FloatGetter)(id obj, SEL selector);

/**
 * CGFloat返回值Get方法
 */
typedef double(* DoubleGetter)(id obj, SEL selector);


@interface GGRuntimeHelper : NSObject

/**
 * 输出属性列表
 */
+ (NSString *)descriptionProperties:(Class)clazz;

/**
 * 输出方法列表
 */
+ (NSString *)descriptionMethods:(Class)clazz;

/**
 * 获取返回值类型
 */
+ (char)methodReturnType:(Method)method;

/**
 * 获取方法指结构体
 */
+ (Method *)floatOrDoubleMethodListForSelectorStringList:(NSArray *)selectors class:(Class)clazz;

/**
 * 获取函数指针
 */
+ (IMP *)getIMPListWithMethods:(Method *)methods size:(size_t)size;

@end
