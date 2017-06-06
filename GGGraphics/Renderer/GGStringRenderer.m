//
//  GGStringRenderer.m
//  111
//
//  Created by _ | Durex on 2017/6/4.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGStringRenderer.h"

typedef enum : NSUInteger {
    AxisType,
    PathType,
    PointType,
} RendererType;

@interface GGStringRenderer ()

@property (nonatomic, assign) RendererType type;

@property (nonatomic, assign) CGPoint point;
@property (nonatomic, copy) NSString * string;

@property (nonatomic, copy) NSArray * aryString;
@property (nonatomic, assign) CGPoint * points;
@property (nonatomic, assign) NSInteger pointCount;

@property (nonatomic, strong) NSMutableDictionary * param;

@end

@implementation GGStringRenderer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _param = [NSMutableDictionary dictionary];
    }
    
    return self;
}

+ (instancetype)stringForAxis:(GGAxis)axis aryStr:(NSArray *)aryStr
{
    GGStringRenderer * renderer = [GGStringRenderer new];
    renderer.type = AxisType;
    renderer.aryString = aryStr;
    [renderer makePointsWithAxis:axis];
    return renderer;
}

+ (instancetype)stringForCGPath:(CGPathRef)ref aryStr:(NSArray *)aryStr
{
    GGStringRenderer * renderer = [GGStringRenderer new];
    renderer.type = PathType;
    renderer.aryString = aryStr;
    return renderer;
}

+ (instancetype)stringForPoint:(CGPoint)point string:(NSString *)string
{
    GGStringRenderer * renderer = [GGStringRenderer new];
    renderer.type = PointType;
    renderer.string = string;
    renderer.point = point;
    return renderer;
}

- (void)makePointsWithAxis:(GGAxis)axis
{
    CGFloat len = GGLengthLine(axis.line);
    NSInteger count = abs((int)(len / axis.sep)) + 1;
    self.pointCount = count;
    self.points = malloc(count * sizeof(CGPoint));
    
    for (int i = 0; i < count; i++) {
        
        CGPoint axis_pt = GGMoveStart(axis.line, axis.sep * i);
        CGPoint over_pt = GGPerpendicularMake(axis.line, axis_pt, axis.over);
        self.points[i] = over_pt;
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    [_param setObject:font forKey:NSFontAttributeName];
}

- (void)setColor:(UIColor *)color
{
    _color = color;
    [_param setObject:color forKey:NSForegroundColorAttributeName];
}

- (void)dealloc
{
    free(_points);
}

- (void)drawInContext:(CGContextRef)ctx
{
    // NSInteger count = _aryString.count > _pointCount ? _pointCount : self.aryString.count;
    
    UIGraphicsPushContext(ctx);
    
    if (self.type == PointType) {
        
        CGPoint drawPoint = CGPointMake(_point.x + _offset.width, _point.y + _offset.height);
        [_string drawAtPoint:drawPoint withAttributes:_param];
    }
    
    
//    for (NSInteger i = 0; i < count; i++) {
//        
//        NSString * string = _aryString[i];
//        CGPoint point = _points[i];
//        NSDictionary *param = @{NSFontAttributeName : _font, NSForegroundColorAttributeName : _color};
//        CGSize size = [string sizeWithAttributes:param];
//        point = CGPointMake(point.x - size.width / 2 + _offset.width, point.y + _offset.height);
//        [string drawAtPoint:point withAttributes:param];
//    }
    
    UIGraphicsPopContext();
}

@end
