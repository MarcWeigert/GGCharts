//
//  LineShape.m
//  HCharts
//
//  Created by 黄舜 on 16/6/16.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "LineShape.h"
#import "DrawMath.h"
#import "CALayer+GraDispose.h"

@interface LineShape ()

@property (nonatomic, weak) CALayer *layer;

@property (nonatomic, readonly) NSArray *dataAry;

@property (nonatomic, readonly) NSNumber *filNumber;

@property (nonatomic, readonly) CGFloat lineWidth;

@property (nonatomic, readonly) UIColor *clr;

@property (nonatomic, readonly) UIColor *filClr;

@property (nonatomic, readonly) NSNumber *lineRow;

@property (nonatomic, readonly) NSNumber *lineIndex;

@end

@implementation LineShape

/** 初始化 */
- (id)initWithLayer:(CALayer *)layer
{
    self = [super init];
    
    if (self) {
        
        _layer = layer;
    }
    
    return self;
}

- (LineShape * (^)(NSArray <NSNumber *> *drawAry))drawAry
{
    return ^ id (NSArray *drawAry) {
        _dataAry = drawAry;
        return self;
    };
}

/** 设置线颜色 */
- (LineShape * (^)(UIColor *color))color
{
    return ^ id (UIColor *color) {
        
        _clr = color;
        
        return self;
    };
}

/** 填充颜色 */
- (LineShape * (^)(UIColor *color))fillColor
{
    return ^ id (UIColor *color) {
        
        _filClr = color;
        
        return self;
    };
}

/** 线宽 */
- (LineShape * (^)(CGFloat width))witdth
{
    return ^ id (CGFloat width) {
        
        _lineWidth = width;
        
        return self;
    };
}

/** 围绕某一个价位填充 */
- (LineShape * (^)(CGFloat rounder))rounder
{
    return ^ id (CGFloat rounder) {
        
        _filNumber = @(rounder);
        
        return self;
    };
}

/** 组 */
- (LineShape * (^)(NSInteger index))index
{
    return ^ id (NSInteger index) {
        
        _lineIndex = @(index);
        
        return self;
    };
}

/** 总组数 */
- (LineShape * (^)(NSInteger row))row
{
    return ^ id (NSInteger row) {
        
        _lineRow = @(row);
        
        return self;
    };
}

/** 绘制传入的层 */
- (NSArray *)stockLayer:(CAShapeLayer *)shapeLayer
{
    NSMutableArray *pointAry = [NSMutableArray array];
    NSInteger count = self.lineRow == nil ? (self.dataAry.count - 1) : self.dataAry.count;
    CGFloat add = 0;
    BOOL isMoveFirst = NO;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint firstPoint = CGPointZero;
    
    FitFunc x = funcLineOffset(count, self.layer.frame.size.width);
    FltFunc y = funcAreaInvert(_layer.max, _layer.min, self.layer.frame.size.height);
    
    if (_lineRow) {
        
        CGFloat sectionWidth = self.layer.frame.size.width / self.dataAry.count;
        CGFloat row = _lineRow.integerValue + 1;
        CGFloat index = _lineIndex.integerValue + 1;
        
        add = sectionWidth * (index / row);
    }
    
    for (NSInteger i = 0; i < self.dataAry.count; i++) {
        
        CGFloat value = [self.dataAry[i] floatValue];
        
        if (value == FLT_MIN) {
        
            [pointAry addObject:[NSValue valueWithCGPoint:CGPointZero]];
            continue;
        }
        
        CGPoint point = CGPointMake(x(i) + add, y(value));
        
        if (isMoveFirst) {
            
            CGPathAddLineToPoint(path, NULL, point.x, point.y);
        }
        else {
            isMoveFirst = YES;
            firstPoint = point;
            CGPathMoveToPoint(path, NULL, point.x, point.y);
        }
        
        [pointAry addObject:[NSValue valueWithCGPoint:point]];
    }
    
    if (self.filNumber != nil) {
        
        CGPoint roundStart = CGPointMake(x(0) + add, y(self.filNumber.floatValue));
        CGPoint roundEnd = CGPointMake(x(self.dataAry.count - 1) + add, y(self.filNumber.floatValue));
        
        // 形成填充回路
        CGPathAddLineToPoint(path, NULL, roundEnd.x, roundEnd.y);
        CGPathAddLineToPoint(path, NULL, roundStart.x, roundStart.y);
        CGPathAddLineToPoint(path, NULL, firstPoint.x, firstPoint.y);
    }
    
    shapeLayer.frame = CGRectMake(0, 0, _layer.frame.size.width, _layer.frame.size.height);
    shapeLayer.lineWidth = self.lineWidth;
    shapeLayer.fillColor = (self.filNumber == nil) ? [UIColor clearColor].CGColor : self.filClr.CGColor;
    shapeLayer.strokeColor = self.clr.CGColor;
    
    CGPathRef ref = CGPathCreateCopy(path);
    shapeLayer.path = ref;
    CFRelease(ref);
    return [NSArray arrayWithArray:pointAry];
}

@end
