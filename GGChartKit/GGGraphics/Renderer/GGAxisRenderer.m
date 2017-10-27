//
//  GGAxisRenderer.m
//  111
//
//  Created by _ | Durex on 2017/5/27.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGAxisRenderer.h"

@interface GGAxisRenderer ()

@property (nonatomic, strong) NSMutableDictionary * paramStr;

@property (nonatomic, strong) NSMutableArray * stringArray;
@property (nonatomic, strong) NSMutableArray * stringPoints;

@property (nonatomic, copy) NSString *(^stringBlock)(CGPoint point, NSInteger index, NSInteger max);

@end

@implementation GGAxisRenderer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _showSep = YES;
        _showLine = YES;
        _showText = YES;
        _drawAxisCenter = NO;
        _offSetRatio = GGRatioBottomRight;
        _range = NSMakeRange(0, 0);
    }
    
    return self;
}

/**
 * Block设置轴分割点文字
 *
 * point 关键点 index 索引值 max 最大值
 */
- (void)setStringBlock:(NSString *(^)(CGPoint point, NSInteger index, NSInteger max))stringBlock;
{
    _stringBlock = stringBlock;
}

/**
 * 清除所有附加文字
 */
- (void)removeAllPointString
{
    [self.stringArray removeAllObjects];
    [self.stringPoints removeAllObjects];
}

/**
 * 增加轴关键点以及文字
 *
 * @param string 文字
 * @param point 点
 */
- (void)addString:(NSString *)string point:(CGPoint)point
{
    if (string == nil) { return; }
    
    [self.stringArray addObject:string];
    [self.stringPoints addObject:[NSValue valueWithCGPoint:point] ];
}

- (void)setStrColor:(UIColor *)strColor
{
    _strColor = strColor;
    [self.paramStr setObject:_strColor forKey:NSForegroundColorAttributeName];
}

- (void)setStrFont:(UIFont *)strFont
{
    _strFont = strFont;
    [self.paramStr setObject:_strFont forKey:NSFontAttributeName];
}

- (NSMutableDictionary *)paramStr
{
    if (!_paramStr) {
        
        _paramStr = [NSMutableDictionary dictionary];
    }
    
    return _paramStr;
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, _width);
    CGContextSetStrokeColorWithColor(ctx, _color.CGColor);
    
    CGPoint ratioPoint = RATIO_POINT_CONVERT(_offSetRatio);
    
    if (_showLine) {
        
        CGContextMoveToPoint(ctx, _axis.line.start.x, _axis.line.start.y);
        CGContextAddLineToPoint(ctx, _axis.line.end.x, _axis.line.end.y);
    }
    
    CGFloat len = GGLengthLine(_axis.line);
    NSInteger count = _axis.sep == 0 ? 0 : abs((int)(len / _axis.sep + 0.1)) + 1;   ///< 八社九入
    
    CGPoint from[count];
    CGPoint to[count];
    
    for (int i = 0; i < count; i++) {
        
        CGPoint axis_pt = GGMoveStart(_axis.line, _axis.sep * i);
        CGPoint over_pt = GGPerpendicularMake(_axis.line, axis_pt, _axis.over);
        
        from[i] = axis_pt;
        to[i] = over_pt;
    }
    
    if (_showSep) {
        
        for (int i = 0; i < count; i++) {
            
            CGPoint axis_pt = from[i];
            CGPoint over_pt = to[i];
            
            CGContextMoveToPoint(ctx, axis_pt.x, axis_pt.y);
            CGContextAddLineToPoint(ctx, over_pt.x, over_pt.y);
        }
    }
    
    CGContextStrokePath(ctx);
    
    if (_showText) {
        
        UIGraphicsPushContext(ctx);
        
        NSInteger drawCount = _aryString.count > count ? count : _aryString.count;
        
        if (NSMaxRange(_range) != 0) {
            
            drawCount = NSMaxRange(_range) > drawCount ? drawCount : NSMaxRange(_range);
        }
        
        CGFloat l_cir = GGXCircular(_axis.line);
        CGFloat cir = l_cir > M_PI_2 ? l_cir - M_PI_2 : l_cir;
        
        for (NSInteger i = _range.location; i < drawCount; i++) {
            
            NSString * string = _aryString[i];
            CGPoint point = to[i];
            CGSize size = [string sizeWithAttributes:_paramStr];
            
            NSMutableDictionary * dicDrawString = [NSMutableDictionary dictionaryWithDictionary:_paramStr];
            
            if (_colorAry.count) {      // 多色值
                
                UIColor * color = _colorAry[i < (_colorAry.count - 1) ? i : (_colorAry.count - 1)];
                [dicDrawString setObject:color forKey:NSForegroundColorAttributeName];
            }
            
            point = CGPointMake(point.x + _textOffSet.width, point.y + _textOffSet.height);
            
            if (_drawAxisCenter) {      // 中心绘制
                
                point = cir > M_PI_4 / 2 ? CGPointMake(point.x, point.y + _axis.sep / 2) : CGPointMake(point.x + _axis.sep / 2, point.y);
            }
            
            point = CGPointMake(point.x + size.width * ratioPoint.x, point.y + size.height * ratioPoint.y);
            
            /** flag 首位缩进 */
            if (_isStringFirstLastindent && i == 0 && !_drawAxisCenter) {
                
                point = to[i];
            }
            
            if (_isStringFirstLastindent && i + 1 == self.aryString.count && !_drawAxisCenter) {
                
                point = cir > M_PI_4 / 2 ? CGPointMake(to[i].x, to[i].y - size.height) : CGPointMake(to[i].x - size.width, to[i].y);
            }
            /** end */
            
            if ([self isDrawTextWithIndex:i]) {     ///< 是否绘制文字
                
                [string drawAtPoint:point withAttributes:dicDrawString];
            }
        }
        
        // 轴上增加关键点以及文字
        [self.stringArray enumerateObjectsUsingBlock:^(NSString * key, NSUInteger idx, BOOL * _Nonnull stop) {
            
            NSValue * obj = self.stringPoints[idx];
            CGSize size = [key sizeWithAttributes:_paramStr];
            CGPoint over_pt = GGPerpendicularMake(_axis.line, obj.CGPointValue, _axis.over);
            CGPoint point = CGPointMake(over_pt.x + size.width * ratioPoint.x, over_pt.y + size.height * ratioPoint.y);
            [key drawAtPoint:point withAttributes:_paramStr];
        }];
        
        UIGraphicsPopContext();
    }
    
    // block 计算轴
    if (self.stringBlock) {
        
        UIGraphicsPushContext(ctx);
        
        for (int i = 0; i < count; i++) {
            
            CGPoint point = to[i];
            NSString * string = self.stringBlock(point, i, count);
            CGSize size = [string sizeWithAttributes:_paramStr];
            point = CGPointMake(point.x + _textOffSet.width, point.y + _textOffSet.height);
            point = CGPointMake(point.x + size.width * ratioPoint.x, point.y + size.height * ratioPoint.y);
            [string drawAtPoint:point withAttributes:_paramStr];
        }
        
        UIGraphicsPopContext();
    }
}

- (BOOL)isDrawTextWithIndex:(NSInteger)index
{
    if (_hiddenPattern.count > 0) {
        
        NSArray * aryAddPattern = [self aryAddUp:_hiddenPattern];
        
        for (NSNumber * number in aryAddPattern) {
            
            if (index % number.integerValue == 0) {
                
                return NO;
            }
        }
        
        return YES;
    }
    
    return YES;
}

- (NSArray *)aryAddUp:(NSArray *)array
{
    NSMutableArray * ary = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSInteger i = 0; i < array.count; i++) {
        
        if (i == 0) {
            
            ary[i] = array[i];
        }
        else {
        
            ary[i] = @([ary[i - 1] floatValue] + [array[i] floatValue]);
        }
    }
    
    return ary;
}

GGLazyGetMethod(NSMutableArray, stringArray);
GGLazyGetMethod(NSMutableArray, stringPoints);

@end
