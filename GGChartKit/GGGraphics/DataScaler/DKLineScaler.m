//
//  DKLineScaler.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "DKLineScaler.h"

typedef double(^KLineScaler)(double record);

/** 纵轴计算 */
KLineScaler kLineScaler(CGFloat max, CGFloat min, CGRect rect)
{
    CGFloat dis = CGRectGetHeight(rect);
    CGFloat div = max - min;
    div = div == 0 ? 1 : div;
    CGFloat pix = dis / div;
    CGFloat zero = CGRectGetMaxY(rect);
    
    return ^(double val) {
        
        return zero - (val - min) * pix;
    };
}

@interface DKLineScaler ()

@property (nonatomic) void * impOpenGetter;     ///< 开盘方法指针
@property (nonatomic) SEL selOpenGetter;        ///< 开盘方法选择

@property (nonatomic) void * impCloseGetter;     ///< 收盘方法指针
@property (nonatomic) SEL selCloseGetter;        ///< 收盘方法选择

@property (nonatomic) void * impHighGetter;     ///< 最高方法指针
@property (nonatomic) SEL selHighGetter;        ///< 最高方法选择

@property (nonatomic) void * impLowGetter;     ///< 最低方法指针
@property (nonatomic) SEL selLowGetter;        ///< 最低方法选择

@property (nonatomic, copy) KLineScaler kFig;     ///< 纵轴换算

@end

@implementation DKLineScaler

/**
 * 自定义k线对象转换转换
 *
 * @param kLineObjAry 模型类数组
 * @param open 模型类方法, 方法无参数, 返回值为CGFloat
 * @param close 模型类方法, 方法无参数, 返回值为CGFloat
 * @param high 模型类方法, 方法无参数, 返回值为CGFloat
 * @param low 模型类方法, 方法无参数, 返回值为CGFloat
 */
- (void)setObjArray:(NSArray <NSObject *> *)kLineObjAry getOpen:(SEL)open getClose:(SEL)close getHigh:(SEL)high getLow:(SEL)low
{
    if (!kLineObjAry.count) { NSLog(@"array is empty"); return; }
    
    _xMaxCount = kLineObjAry.count;
    _kLineObjAry = kLineObjAry;
    
    _selOpenGetter = open;
    _impOpenGetter = [kLineObjAry.firstObject methodForSelector:_selOpenGetter];
    _selCloseGetter = close;
    _impCloseGetter = [kLineObjAry.firstObject methodForSelector:_selCloseGetter];
    _selHighGetter = high;
    _impHighGetter = [kLineObjAry.firstObject methodForSelector:_selHighGetter];
    _selLowGetter = low;
    _impLowGetter = [kLineObjAry.firstObject methodForSelector:_selLowGetter];
    
    GGKShape * kShapes = malloc(_kLineObjAry.count * sizeof(GGKShape));
    [self updateKLineShapes:kShapes];
}

- (void)updateKLineShapes:(GGKShape *)kLineShapes
{
    if (_kShapes != nil) {
        
        free(_kShapes);
    }
    
    _kShapes = kLineShapes;
}

- (CGSize)contentSize
{
    return CGSizeMake((self.shapeInterval + self.shapeWidth) * _xMaxCount, self.rect.size.height);
}

- (void)dealloc
{
    if (_kShapes != nil) {
        
        free(_kShapes);
    }
}

/** 根据点获取价格 */
- (CGFloat)getPriceWithPoint:(CGPoint)point
{
    CGFloat dis = CGRectGetHeight(self.rect);
    CGFloat pix = (_max - _min) / dis;
    CGFloat hight = CGRectGetMaxY(self.rect) - point.y;
    
    return _min + hight * pix;
}

/** 更新计算点 */
- (void)updateScalerWithRange:(NSRange)range
{
    _kFig = kLineScaler(_max, _min, self.rect);
    
    CGFloat (* openGetter)(id obj, SEL getter) = self.impOpenGetter;
    CGFloat (* closeGetter)(id obj, SEL getter) = self.impCloseGetter;
    CGFloat (* highGetter)(id obj, SEL getter) = self.impHighGetter;
    CGFloat (* lowGetter)(id obj, SEL getter) = self.impLowGetter;
    
    NSInteger count = NSMaxRange(range);
    
    for (NSInteger idx = range.location; idx < count; idx++) {
        
        NSObject * obj = [_kLineObjAry objectAtIndex:idx];
        
        CGFloat x = (idx + .5) * self.shapeInterval + (idx + .5) * self.shapeWidth;
        
        CGFloat openPrice = openGetter(obj, self.selOpenGetter);
        CGFloat closePrice = closeGetter(obj, self.selCloseGetter);
        CGFloat lowPrice = lowGetter(obj, self.selLowGetter);
        CGFloat highPrice = highGetter(obj, self.selHighGetter);
        
        CGPoint openPoint = CGPointMake(x, _kFig(openPrice));
        CGPoint closePoint = CGPointMake(x, _kFig(closePrice));
        CGPoint lowPoint = CGPointMake(x, _kFig(lowPrice));
        CGPoint highPoint = CGPointMake(x, _kFig(highPrice));
        
        CGRect kRect = GGLineDownRectMake(openPoint, closePoint, self.shapeWidth);
        _kShapes[idx] = GGKShapeRectMake(highPoint, kRect, lowPoint);
    }
}

- (void)updateScaler
{
    [self updateScalerWithRange:NSMakeRange(0, _kLineObjAry.count)];
}

@end
