//
//  GGGrid.m
//  HSCharts
//
//  Created by 黄舜 on 16/12/30.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "GGGridPaint.h"

@implementation GGAxis

- (instancetype)initWithCGAxis:(CGAxis)axis
{
    self = [super init];
    
    if (self) {
        _axis = axis;
    }
    
    return self;
}

+ (instancetype)axisWithCGAxis:(CGAxis)axis
{
    GGAxis *ggAxis = [[GGAxis alloc] initWithCGAxis:axis];
    return ggAxis;
}

@end

@interface GGGridPaint ()

@property (nonatomic, strong) NSMutableArray <GGAxis *>*aryX;
@property (nonatomic, strong) NSMutableArray <GGAxis *>*aryY;

@end

@implementation GGGridPaint

/** 初始化 */
- (instancetype)initWithRect:(CGRect)rect grid:(CGGrid)grid
{
    self = [super init];
    
    if (self) {
        _rect = rect;
        _grid = grid;
        _aryX = [NSMutableArray array];
        _aryY = [NSMutableArray array];
    }
    
    return self;
}

+ (instancetype)gridWithRect:(CGRect)rect grid:(CGGrid)grid
{
    GGGridPaint *ggrid = [[GGGridPaint alloc] initWithRect:rect grid:grid];
    return ggrid;
}

/** 画板接口 */
- (void (^)(CGContextRef))drawForContextRef
{
    __block CGFloat width = _width;
    __block UIColor *color = _color;
    __block CGRect rect = _rect;
    __block CGGrid grid = _grid;
    __block CGFloat space_x = rect.size.width / (grid.x - 1);
    __block CGFloat space_y = rect.size.height / (grid.y - 1);
    
    __block NSArray <GGAxis *>* xAxis = [NSArray arrayWithArray:_aryX];
    __block NSArray <GGAxis *>* yAxis = [NSArray arrayWithArray:_aryY];
    
    return ^(CGContextRef context) {
        
        CGContextSetStrokeColorWithColor(context, color.CGColor);
        CGContextSetLineWidth(context, width);
        CGContextAddRect(context, rect);
        
        CGPoint start = rect.origin;
        CGPoint end = CGPointMake(rect.origin.x, rect.origin.y + rect.size.height);
        for (int i = 1; i < grid.x; i++) {
            CGContextMoveToPoint(context, start.x + i * space_x, start.y);
            CGContextAddLineToPoint(context, end.x + i * space_x, end.y);
        }
        
        end = CGPointMake(rect.origin.x + rect.size.width, rect.origin.y);
        for (int i = 1; i < grid.y; i++) {
            CGContextMoveToPoint(context, start.x, start.y + i * space_y);
            CGContextAddLineToPoint(context, end.x, end.y + i * space_y);
        }
        
        CGContextStrokePath(context);
        
        // x轴绘制
        for (GGAxis *axis in xAxis) {
            
            CGFloat interval_x = rect.size.width / (axis.titles.count - 1);
            
            CGContextSetStrokeColorWithColor(context, axis.color.CGColor);
        }
    };
}

/** 增加轴 */
- (void)addAxisForX:(GGAxis *)axis
{
    [_aryX addObject:axis];
}

- (void)addAxisForY:(GGAxis *)axis
{
    [_aryY addObject:axis];
}

@end
