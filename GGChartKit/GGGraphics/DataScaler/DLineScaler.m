//
//  DLineScaler.m
//  HSCharts
//
//  Created by _ | Durex on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "DLineScaler.h"

typedef double(^LineScaler)(double record);

/** 纵轴计算 */
LineScaler y_axiScaler(CGFloat max, CGFloat min, CGRect rect)
{
    CGFloat dis = CGRectGetHeight(rect);
    CGFloat div = max - min;
    div = div == 0 ? 1 : div;
    CGFloat pix = dis / div;
    
    CGFloat zero = min > 0 ? dis + rect.origin.y : dis - pix * fabs(min) + rect.origin.y;
    
    return ^(double val) {
        
        if (val < 0) {
            
            return zero + fabs(val) * pix;
        }
        else {
            
            if (min < 0) {
                
                return zero - fabs(val) * pix;
            }
            
            return zero - fabs(val - min) * pix;
        }
    };
}

/** 横轴计算 */
LineScaler x_axiScaler(NSInteger sep, CGRect rect, CGFloat base)
{
    sep = base == 0 ? sep - 1 : sep;    // 基数为0则减一
    
    CGFloat interval = CGRectGetWidth(rect) / sep;
    
    return ^(double index) {
        
        return base * interval + index * interval + rect.origin.x;
    };
}

@interface DLineScaler ()

@property (nonatomic, copy) LineScaler fig;     ///< 纵轴换算
@property (nonatomic, copy) LineScaler axis;    ///< 横轴换算

@property (nonatomic) void * impGetter;     ///< 对象方法指针
@property (nonatomic) SEL selGetter;        ///< 对象方法选择

@end

@implementation DLineScaler

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _xRatio = .5f;
    }
    
    return self;
}

/**
 * 环绕点
 */
- (CGFloat)aroundY
{
    if (_aroundNumber) {
        
        return [self getYPixelWithData:_aroundNumber.floatValue];
    }
    
    return CGRectGetMaxY(self.rect);
}

/**
 * 设置定标器最小值
 */
- (void)setMin:(CGFloat)min
{
    _min = min;
    
    if (self.aroundNumber && _min > self.aroundNumber.floatValue) {  // 如果最小值大于aroundNumber, 则重新设置最小值
        
        _min = self.aroundNumber.floatValue;
    }
}

/**
 * 设置环绕加个点
 */
- (void)setAroundNumber:(NSNumber *)aroundNumber
{
    _aroundNumber = aroundNumber;
    
    if (self.aroundNumber && _min > self.aroundNumber.floatValue) {  // 如果最小值大于aroundNumber, 则重新设置最小值
        
        _min = self.aroundNumber.floatValue;
    }
}

/**
 * 自定义对象转换转换
 *
 * @param objAry 模型类数组
 * @param getter 模型类方法, 方法无参数, 返回值为float, 否则会崩溃。
 */
- (void)setObjAry:(NSArray <NSObject *> *)objAry getSelector:(SEL)getter
{
    if (!objAry.count) { NSLog(@"array is empty"); return; }
    
    if (_xMaxCount == 0) {
        
        _xMaxCount = objAry.count;
    }
    
    _pointSize = objAry.count;
    _lineObjAry = objAry;
    _selGetter = getter;
    _impGetter = [objAry.firstObject methodForSelector:getter];
    CGPoint * point = malloc(_lineObjAry.count * sizeof(CGPoint));
    [self updateLinePoints:point];
}

/** 获取价格点 */
- (CGFloat)getYPixelWithData:(CGFloat)data
{
    return _fig(data);
}

/** 根据点获取价格 */
- (CGFloat)getPriceWithPoint:(CGPoint)point
{
    CGFloat dis = CGRectGetHeight(self.rect);
    CGFloat pix = (_max - _min) / dis;
    CGFloat hight = self.rect.size.height - (point.y - self.rect.origin.y);
    
    if (hight < 0) { hight = 0; }
    
    return _min + hight * pix;
}

/** 根据点获取价格 */
- (CGFloat)getPriceWithYPixel:(CGFloat)y
{
    CGFloat dis = CGRectGetHeight(self.rect);
    CGFloat pix = (_max - _min) / dis;
    CGFloat hight = self.rect.size.height - (y - self.rect.origin.y);
    
    if (hight < 0) { hight = 0; }
    
    return _min + hight * pix;
}

/**
 * 根据点获取价格
 *
 * @param y y轴坐标
 * @param max 最大值
 * @param min 最小值
 *
 * @return 价格点
 */
+ (CGFloat)getPriceWithYPixel:(CGFloat)y line:(GGLine)line max:(CGFloat)max min:(CGFloat)min
{
    CGFloat dis = GGLengthLine(line);
    CGFloat pix = (max - min) / dis;
    CGFloat hight = dis - (y - line.start.y);
    
    if (hight < 0) { hight = 0; }
    
    return min + hight * pix;
}

- (void)setDataAry:(NSArray<NSNumber *> *)dataAry
{
    _dataAry = dataAry;
    
    if (_xMaxCount == 0) {
        
        _xMaxCount = dataAry.count;
    }
    
    _pointSize = dataAry.count;
    CGPoint * point = malloc(dataAry.count * sizeof(CGPoint));
    [self updateLinePoints:point];
}

- (void)updateLinePoints:(CGPoint *)linePoints
{
    if (_linePoints != nil) {
        
        free(_linePoints);
    }
    
    _linePoints = linePoints;
}

/** 更新计算点 */
- (void)updateScaler
{
    _fig = y_axiScaler(_max, _min, self.rect);
    _axis = x_axiScaler(_xMaxCount, self.rect, _xRatio);
    
    if (_lineObjAry.count) {
        
        [self.lineObjAry enumerateObjectsUsingBlock:^(NSObject * obj, NSUInteger idx, BOOL * stop) {
            
            CGFloat (* lineGetter)(id obj, SEL getter) = self.impGetter;
            
            if (lineGetter(obj, _selGetter) == FLT_MIN) { _linePoints[idx] = CGPointMake(FLT_MIN, FLT_MIN); return; }
            
            _linePoints[idx] = CGPointMake(_axis(idx), _fig(lineGetter(obj, _selGetter)));
        }];
    }
    else {
        
        [self.dataAry enumerateObjectsUsingBlock:^(NSNumber * obj, NSUInteger idx, BOOL * stop) {
            
            if (obj.floatValue == FLT_MIN) { _linePoints[idx] = CGPointMake(FLT_MIN, FLT_MIN); return; }
            
            _linePoints[idx] = CGPointMake(_axis(idx), _fig(obj.floatValue));
        }];
    }
}

/** 区域更新计算点 */
- (void)updateScalerWithRange:(NSRange)range
{
    NSInteger start = range.location;
    NSInteger end = NSMaxRange(range);
    
    _fig = y_axiScaler(_max, _min, self.rect);
    _axis = x_axiScaler(_xMaxCount, self.rect, _xRatio);
    
    if (_lineObjAry.count) {
        
        for (NSInteger idx = start; idx < end; idx++) {
            
            NSObject * obj = _lineObjAry[idx];
            CGFloat (* lineGetter)(id obj, SEL getter) = self.impGetter;
            if (lineGetter(obj, _selGetter) == FLT_MIN) { _linePoints[idx] = CGPointMake(FLT_MIN, FLT_MIN); continue; }
            _linePoints[idx] = CGPointMake(_axis(idx), _fig(lineGetter(obj, _selGetter)));
        }
    }
    else {
        
        for (NSInteger idx = start; idx < end; idx++) {
            
            NSNumber * obj = _dataAry[idx];
            if (obj.floatValue == FLT_MIN) { _linePoints[idx] = CGPointMake(FLT_MIN, FLT_MIN); continue; }
            _linePoints[idx] = CGPointMake(_axis(idx), _fig(obj.floatValue));
        }
    }
}

/** 靠近点的数据index */
- (NSUInteger)indexOfPoint:(CGPoint)point
{
    CGFloat xSpileWidth = CGRectGetWidth(self.rect) / _xMaxCount;
    CGFloat offSet = xSpileWidth * _xRatio;
    NSInteger index = (point.x - self.rect.origin.x - offSet) / xSpileWidth;
    if (index < 0) { index = 0; }
    if (index >= self.dataAry.count) { index = self.dataAry.count - 1; }
    return index;
}

- (void)dealloc
{
    if (_linePoints != nil) {
        
        free(_linePoints);
        _linePoints = nil;
    }
}

@end
