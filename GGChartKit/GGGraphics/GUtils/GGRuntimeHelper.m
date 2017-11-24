//
//  GGRuntimeHelper.m
//  GGCharts
//
//  Created by 黄舜 on 2017/11/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGRuntimeHelper.h"

@implementation GGRuntimeHelper

/**
 * 输出属性列表
 */
+ (NSString *)descriptionProperties:(Class)clazz
{
    NSString * description = @"\n";
    
    unsigned int count;
    objc_property_t * propertys = class_copyPropertyList(clazz, &count);
    
    for (int i = 0; i < count; i++) {
        
        objc_property_t property = propertys[i];
        
        NSString *property_attr = [NSString stringWithCString:property_getAttributes(property)
                                                     encoding:NSUTF8StringEncoding];
        
        NSString *property_name = [NSString stringWithCString:property_getName(property)
                                                     encoding:NSUTF8StringEncoding];
        
        description = [NSString stringWithFormat:@"%@%@     %@\n", description, property_name, property_attr];
    }
    
    free(propertys);
    
    return description;
}

/**
 * 输出方法列表
 */
+ (NSString *)descriptionMethods:(Class)clazz
{
    NSString * description = @"\n";
    
    unsigned int count = 0;
    Method * methods = class_copyMethodList(clazz, &count);
    
    for(int i= 0; i < count; i++)
    {
        Method method = methods[i];
        const char * name_s = sel_getName(method_getName(method));
        int arguments = method_getNumberOfArguments(method);
        const char * encoding = method_getTypeEncoding(method);
        
        description = [NSString stringWithFormat:@"%@方法名:%@, 参数个数:%zd, 编码方式:%@\n",
                       description,
                       [NSString stringWithUTF8String:name_s],
                       arguments,
                       [NSString stringWithUTF8String:encoding]];
    }
    
    free(methods);
    
    return description;
}

/**
 * 获取返回值类型
 */
+ (char)methodReturnType:(Method)method
{
    const char * type = method_copyReturnType(method);
    if (type) { return type[0]; }
    return 'n';
}

/**
 * 获取方法指针结构体
 */
+ (Method *)floatOrDoubleMethodListForSelectorStringList:(NSArray *)selectors class:(Class)clazz
{
    Method * methods = malloc(sizeof(Method) * selectors.count);
    
    for (int i = 0; i < selectors.count; i++) {
        
        SEL selector = NSSelectorFromString(selectors.firstObject);
        methods[i] = class_getInstanceMethod([NSNumber class], selector);
    }
    
    return methods;
}

/**
 * 获取函数指针
 */
+ (IMP *)getIMPListWithMethods:(Method *)methods size:(size_t)size
{
    IMP * imps = malloc(sizeof(IMP) * size);
    
    for (int i = 0; i < size; i++) {
        
        imps[i] = method_getImplementation(methods[i]);
    }
    
    return imps;
}

@end
