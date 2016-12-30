//
//  GGLineBrush.m
//  HSCharts
//
//  Created by 黄舜 on 16/12/29.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "GGLineBrush.h"

@interface GGLineBrush ()

@property (nonatomic, strong) NSArray <NSValue *>* points;

@end

@implementation GGLineBrush

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _points = [NSMutableArray array];
    }
    
    return self;
}

+ (instancetype)lineBrushWithLine:(id <GGPointProtocol>)line
{
    GGLineBrush *brush = [[GGLineBrush alloc] init];
    brush.points = line.linePoints;
    return brush;
}

+ (instancetype)lineBrushWithFrom:(CGPoint)from to:(CGPoint)to
{
    GGLineBrush *brush = [[GGLineBrush alloc] init];
    brush.points = @[[NSValue valueWithCGPoint:from], [NSValue valueWithCGPoint:to]];
    return brush;
}

/** 继承接口 */
- (void (^)(CGContextRef))drawForContextRef
{
    CGFloat width = _width;
    UIColor *color = _color;
    NSArray *points = _points;
    
    return ^(CGContextRef context) {
    
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, width);
        
        for (int i = 0; i < points.count; i++) {
            CGPoint pt = [points[i] CGPointValue];
            i == 0 ? CGContextMoveToPoint(context, pt.x, pt.y) : CGContextAddLineToPoint(context, pt.x, pt.y);
        }
        
        CGContextStrokePath(context);
    };
}

@end
