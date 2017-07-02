//
//  DPieScaler.m
//  HSCharts
//
//  Created by _ | Durex on 2017/7/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "DPieScaler.h"

@interface DPieScaler ()

@property (nonatomic) void * impGetter;     ///< 对象方法指针
@property (nonatomic) SEL selGetter;        ///< 对象方法选择

@end

@implementation DPieScaler

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _baseArc = M_PI_2;
    }
    
    return self;
}

- (void)dealloc
{
    if (_arcs) { free(_arcs); }
    
    if (_transArcs) { free(_transArcs); }
    
    if (_ratios) { free(_ratios); }
}

- (void)updateArcs:(CGFloat *)arcs
{
    if (_arcs) {
        
        free(_arcs);
    }
    
    _arcs = arcs;
}

- (void)updateTransArcs:(CGFloat *)transArcs
{
    if (_transArcs) {
    
        free(_transArcs);
    }
    
    _transArcs = transArcs;
}

- (void)updateRatios:(CGFloat *)ratios
{
    if (_ratios) {
        
        free(_ratios);
    }
    
    _ratios = ratios;
}

/**
 * 自定义对象转换转换, 如果设置则忽略dataAry
 *
 * @param objAry 模型类数组
 * @param getter 模型类方法, 方法无参数, 返回值为CGFloat, 否则会崩溃。
 */
- (void)setObjAry:(NSArray <NSObject *> *)objAry getSelector:(SEL)getter
{
    if (!objAry.count) { NSLog(@"array is empty"); return; }
    
    _pieObjAry = objAry;
    _selGetter = getter;
    _impGetter = [objAry.firstObject methodForSelector:getter];
    CGFloat * arcs = malloc(_pieObjAry.count * sizeof(CGFloat));
    CGFloat * transArcs = malloc(_pieObjAry.count * sizeof(CGFloat));
    CGFloat * ratios = malloc(_pieObjAry.count * sizeof(CGFloat));
    [self updateArcs:arcs];
    [self updateTransArcs:transArcs];
    [self updateRatios:ratios];
}

/** 更新计算点 */
- (void)updateScaler
{
    _sum = 0;
    
    CGFloat (* pieGetter)(id obj, SEL getter) = self.impGetter;
    
    [_pieObjAry enumerateObjectsUsingBlock:^(NSObject * obj, NSUInteger idx, BOOL * stop) {
        
        _sum += pieGetter(obj, _selGetter);
    }];
    
    __block CGFloat layer_arc = 0;
    
    [_pieObjAry enumerateObjectsUsingBlock:^(NSObject * obj, NSUInteger idx, BOOL * stop) {
        
        _arcs[idx] = pieGetter(obj, _selGetter) / _sum * M_PI * 2;
        layer_arc += _arcs[idx];
        _transArcs[idx] =  M_PI * 2 - layer_arc - _baseArc;
        _ratios[idx] = _arcs[idx] / (M_PI * 2);
    }];
}

@end
