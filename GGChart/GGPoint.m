//
//  GGLine.m
//  HSCharts
//
//  Created by 黄舜 on 16/12/29.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "GGPoint.h"

@interface GGPoint ()

@property (nonatomic, assign) CGPoint point;

@property (nonatomic, strong) NSMutableArray <NSValue *>*pointAry;

@end

@implementation GGPoint

+ (instancetype)pointWithPoint:(CGPoint)point
{
    GGPoint *pt = [GGPoint new];
    pt.point = point;
    return pt;
}

- (NSArray <NSValue *>*)linePoints
{
    return @[[NSValue valueWithCGPoint:_point]];
}

@end

@interface GGLine ()

@property (nonatomic, assign) CGPoint from;
@property (nonatomic, assign) CGPoint to;

@end

@implementation GGLine

+ (instancetype)lineWithFrom:(CGPoint)from to:(CGPoint)to
{
    GGLine *line = [GGLine new];
    line.from = from;
    line.to = to;
    return line;
}

- (NSArray <NSValue *>*)linePoints
{
    return @[[NSValue valueWithCGPoint:_from], [NSValue valueWithCGPoint:_to]];
}

@end

@interface GGMeanderLine ()

@property (nonatomic, strong) NSArray <NSValue *>* points;

@end

@implementation GGMeanderLine

+ (instancetype)meanderLineWithArray:(NSArray <NSValue *>*)array
{
    GGMeanderLine *line = [GGMeanderLine new];
    line.points = array;
    return line;
}

- (NSArray <NSValue *>*)linePoints
{
    return _points;
}

@end
