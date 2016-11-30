//
//  RoundShape.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/13.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "RoundShape.h"
#import "DrawMath.h"

@interface RoundShape ()

@property (nonatomic, weak) CALayer *layer;     ///< 绘制

@property (nonatomic) NSValue *centerPt;        ///< 圆中心点

@property (nonatomic) UIColor *edgeClr;         ///< 边缘颜色

@property (nonatomic) UIColor *fillClr;         ///< 填充颜色

@property (nonatomic) NSNumber *edgeW;          ///< 边缘宽度

@property (nonatomic) NSNumber *rad;            ///< 半径

@property (nonatomic) NSArray <NSNumber *>* dataAry;    ///< 数据

@property (nonatomic) NSInteger drawIndex;          ///< 绘制数据

@end

@implementation RoundShape

/** 初始化 */
- (id)initWithLayer:(CALayer *)layer
{
    self = [super init];
    
    if (self) {
        
        _layer = layer;
    }
    
    return self;
}

/** 设置填充颜色 */
- (RoundShape * (^)(UIColor *color))fillColor
{
    return ^(UIColor *color) {
    
        _fillClr = color;
        
        return self;
    };
}

/** 设置边缘颜色 */
- (RoundShape * (^)(UIColor *color))edgeColor
{
    return ^(UIColor *color) {
        
        _edgeClr = color;
        
        return self;
    };
}

/** 设置边缘颜色 */
- (RoundShape * (^)(NSArray *drawAry, NSInteger drawIndex))drawAry
{
    return ^(NSArray *drawAry, NSInteger drawIndex) {
        
        _drawIndex = (drawAry.count <= drawIndex) ? drawAry.count - 1 : drawIndex;
        _dataAry = drawAry;
        
        return self;
    };
}

/** 设置边缘颜色 */
- (RoundShape * (^)(CGPoint center))centerPoint
{
    return ^(CGPoint center) {
        
        _centerPt = [NSValue valueWithCGPoint:center];
        
        return self;
    };
}

/** 设置边缘颜色 */
- (RoundShape * (^)(CGFloat radius))radius
{
    return ^(CGFloat radius) {
        
        _rad = @(radius);
        
        return self;
    };
}

/** 设置边缘颜色 */
- (RoundShape * (^)(CGFloat width))edgeWidth
{
    return ^(CGFloat width) {
        
        _edgeW = @(width);
        
        return self;
    };
}

/** 绘制传入的层 */
- (NSArray *)stockLayer:(CAShapeLayer *)shapeLayer
{
    CGPoint center = self.centerPt == nil ? CGPointMake(_layer.frame.size.width / 2, _layer.frame.size.height / 2) : _centerPt.CGPointValue;
    
    CGFloat start = 0;
    CGFloat end = 360;
    BOOL isData = false;
    
    if (_dataAry != nil && _dataAry.count > 1) {
        
        CGFloat sumOfData = addToIndex(_dataAry, _dataAry.count - 1);
        CGFloat startVl = addToIndex(_dataAry, _drawIndex - 1);
        CGFloat endVl = addToIndex(_dataAry, _drawIndex);
        
        start = 360 * startVl / sumOfData;
        end = 360 * endVl / sumOfData;
        isData = true;
    }
    
    // 关闭隐士动画
    [CATransaction setDisableActions:YES];
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    if (isData && _edgeW == nil) {
        
        CGPathMoveToPoint(path, NULL, center.x, center.y);
    }
    
    CGPathAddArc(path, NULL, center.x, center.y, _rad.floatValue + _edgeW.floatValue / 2, degreesToRadians(start), degreesToRadians(end), NO);
    
    if (isData && _edgeW == nil) {
        
        CGPathAddLineToPoint(path, NULL, center.x, center.y);
    }
    
    shapeLayer.fillColor = _fillClr == nil ? nil : _fillClr.CGColor;
    shapeLayer.strokeColor = _edgeClr.CGColor;
    shapeLayer.lineWidth = _edgeW.floatValue;
    shapeLayer.path = path;
    CFRelease(path);
    
    return @[@(start), @(end)];     // 起始角度
}

@end
