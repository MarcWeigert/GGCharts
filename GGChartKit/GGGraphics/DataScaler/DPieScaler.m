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
        
        _baseArc = -M_PI_2;
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

- (void)updatePies:(GGPie *)pies
{
    if (_pies) {
        
        free(_pies);
    }
    
    _pies = pies;
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
    GGPie * pies = malloc(_pieObjAry.count * sizeof(GGPie));
    
    [self updateArcs:arcs];
    [self updateTransArcs:transArcs];
    [self updateRatios:ratios];
    [self updatePies:pies];
}

/** 更新计算点 */
- (void)updateScaler
{
    _sum = 0;
    
    CGFloat (* pieGetter)(id obj, SEL getter) = self.impGetter;
    
    [_pieObjAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        
        if ([obj isKindOfClass:[NSNumber class]]) {
            
            _sum += [obj floatValue];
        }
        else {
            
            _sum += pieGetter(obj, _selGetter);
        }
    }];
    
    __block CGFloat layer_arc = 0;
    
    [_pieObjAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        
        CGFloat arc;
        
        if ([obj isKindOfClass:[NSNumber class]]) {
            
            arc = [obj floatValue] / _sum * M_PI * 2;
        }
        else {
            
            arc = pieGetter(obj, _selGetter) / _sum * M_PI * 2;
        }
        
        layer_arc += arc;
        CGFloat transArcs = layer_arc - arc + _baseArc;
        CGFloat ratios = arc / (M_PI * 2);
        
        _arcs[idx] = arc;
        _transArcs[idx] = transArcs;
        _ratios[idx] = ratios;
        _pies[idx] = GGPieMake(0, 0, _inRadius, _outRadius, arc, transArcs);
    }];
}

@end
