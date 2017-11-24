//
//  BaseMinimaxScaler.m
//  GGCharts
//
//  Created by 黄舜 on 2017/11/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseMinimaxScaler.h"
#import "GGRuntimeHelper.h"

@interface BaseMinimaxScaler()

/**
 * 获取大小定标方法列表指针
 */
@property (nonatomic, assign) Method * scalerMethodList;

/**
 * 函数指针
 */
@property (nonatomic, assign) IMP * scalerIMPList;

@end

@implementation BaseMinimaxScaler

- (void)dealloc
{
    if (_scalerMethodList) { free(_scalerMethodList); }
    if (_scalerIMPList) { free(_scalerIMPList); }
}

- (void)setScalerMethodList:(Method *)scalerMethodList
{
    if (_scalerMethodList) { free(_scalerMethodList); }
    _scalerMethodList = scalerMethodList;
}

- (void)setScalerIMPList:(IMP *)scalerIMPList
{
    if (_scalerIMPList) { free(_scalerIMPList); }
    _scalerIMPList = scalerIMPList;
}

/**
 * 极大极小值方法定标方法
 *
 * @param array 定标器数组
 * @param getters 获取方法
 */
- (void)setObjectAry:(NSArray <NSObject *> *)array floatOrDoubleGetters:(NSArray *)getters
{
    self.scalerMethodList = [GGRuntimeHelper floatOrDoubleMethodListForSelectorStringList:getters class:[array.firstObject class]];
    self.scalerIMPList = [GGRuntimeHelper getIMPListWithMethods:self.scalerMethodList size:getters.count];
    
    for (int i = 0; i < array.count; i++) {
        
        for (int j = 0; j < getters.count; j++) {
            
            Method method = self.scalerMethodList[j];
            char rt = [GGRuntimeHelper methodReturnType:method];
            IMP imp = self.scalerIMPList[j];
            
            CGFloat number = .0f;
            if ('f' == rt) { number = ((FloatGetter)imp)(array[i], method_getName(method)); }
            else if ('d' == rt) { number = ((DoubleGetter)imp)(array[i], method_getName(method)); }
        }
    }
}

@end
