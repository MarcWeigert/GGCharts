//
//  BarShape.m
//  HCharts
//
//  Created by _ | Durex on 16/6/18.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "BarShape.h"
#import "DrawMath.h"
#import "CALayer+GraDispose.h"

@interface BarShape ()

@property (nonatomic, weak) CALayer *layer;

@property (nonatomic, readonly) NSArray *dataAry;

@property (nonatomic, readonly) CGFloat barWidth;

@property (nonatomic, readonly) UIColor *clr;

@property (nonatomic, readonly) NSNumber *barRow;

@property (nonatomic, readonly) NSNumber *barIndex;

@end

@implementation BarShape

/** 初始化 */
- (id)initWithLayer:(CALayer *)layer
{
    self = [super init];
    
    if (self) {
        
        _layer = layer;
    }
    
    return self;
}

/** 设置绘制数组 */
- (BarShape * (^)(NSArray <NSNumber *> *drawAry))drawAry
{
    return ^ id (NSArray *drawAry) {
        
        _dataAry = drawAry;
        
        return self;
    };
}

/** 设置线颜色 */
- (BarShape * (^)(UIColor *color))color
{
    return ^ id (UIColor *color) {
        
        _clr = color;
        
        return self;
    };
}

/** 线宽 */
- (BarShape * (^)(CGFloat width))witdth
{
    return ^ id (CGFloat width) {
        
        _barWidth = width;
        
        return self;
    };
}

/** 组 */
- (BarShape * (^)(NSInteger index))index
{
    return ^ id (NSInteger index) {
        
        _barIndex = @(index);
        
        return self;
    };
}

/** 总组数 */
- (BarShape * (^)(NSInteger row))row
{
    return ^ id (NSInteger row) {
        
        _barRow = @(row);
        
        return self;
    };
}

/** 绘制传入的层 */
- (NSArray *)stockLayer:(CAShapeLayer *)shapeLayer;
{
    NSMutableArray *pointAry = [NSMutableArray array];
    CGFloat sectionWidth = self.layer.frame.size.width / self.dataAry.count;
    CGFloat baseData = self.layer.min <= 0 ? 0 : self.layer.min;
    CGFloat add = sectionWidth / 2;
    
    if (_barRow) {
        
        CGFloat row = _barRow.integerValue + 1;
        CGFloat index = _barIndex.integerValue + 1;
        
        add = sectionWidth * (index / row);
    }
    
    FitFunc x = funcLineOffset(self.dataAry.count, self.layer.frame.size.width);
    FltFunc y = funcAreaInvert(_layer.max, _layer.min, self.layer.frame.size.height);
    
    CGMutablePathRef path = CGPathCreateMutable();
    
    for (NSInteger i = 0; i < self.dataAry.count; i++) {
        
        CGFloat value = [self.dataAry[i] floatValue];
        
        if (value == FLT_MIN) {
        
            [pointAry addObject:[NSValue valueWithCGPoint:CGPointZero]];
            continue;
        }
        
        CGFloat loaction_x = x(i) + add;
        CGFloat start_y = y(baseData);
        CGFloat end_y = y(value);
        
        CGMutablePathRef addPath = CGPathCreateMutable();
        CGPathMoveToPoint(addPath, NULL, loaction_x, start_y);
        CGPathAddLineToPoint(addPath, NULL, loaction_x, end_y);
        CGPathAddPath(path, NULL, addPath);
        CFRelease(addPath);
        
        [pointAry addObject:[NSValue valueWithCGPoint:CGPointMake(loaction_x, end_y)]];
    }
    
    shapeLayer.frame = CGRectMake(0, 0, _layer.frame.size.width, _layer.frame.size.height);
    shapeLayer.lineWidth = self.barWidth;
    shapeLayer.strokeColor = self.clr.CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    CGPathRef ref = CGPathCreateCopy(path);
    shapeLayer.path = ref;
    CFRelease(ref);
    
    return [NSArray arrayWithArray:pointAry];
}

@end
