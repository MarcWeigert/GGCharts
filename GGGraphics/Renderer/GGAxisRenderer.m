//
//  GGAxisRenderer.m
//  111
//
//  Created by _ | Durex on 2017/5/27.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGAxisRenderer.h"
#import "GGChartDefine.h"

@interface GGAxisRenderer ()

@property (nonatomic, strong) NSMutableDictionary * paramStr;

@property (nonatomic, strong) NSMutableDictionary * dictionaryString;

@property (nonatomic, copy) NSString *(^stringBlock)(CGPoint point, NSInteger index, NSInteger max);

@end

@implementation GGAxisRenderer

- (void)setStringBlock:(NSString *(^)(CGPoint point, NSInteger index, NSInteger max))stringBlock;
{
    _stringBlock = stringBlock;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _showSep = YES;
        _showLine = YES;
        _showText = YES;
        _drawAxisCenter = NO;
        _offSetRatio = CGPointMake(0, 0);
        _range = NSMakeRange(0, 0);
    }
    
    return self;
}

- (void)addString:(NSString *)string point:(CGPoint)point
{
    [self.dictionaryString setValue:[NSValue valueWithCGPoint:point] forKey:string];
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
    
    if (_showLine) {
        
        CGContextMoveToPoint(ctx, _axis.line.start.x, _axis.line.start.y);
        CGContextAddLineToPoint(ctx, _axis.line.end.x, _axis.line.end.y);
    }
    
    CGFloat len = GGLengthLine(_axis.line);
    NSInteger count = _axis.sep == 0 ? 0 : abs((int)(len / _axis.sep)) + 1;
    
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
            
            point = CGPointMake(point.x + _textOffSet.width, point.y + _textOffSet.height);
            
            if (_drawAxisCenter) {
                
                point = cir > M_PI_4 / 2 ? CGPointMake(point.x, point.y + _axis.sep / 2) : CGPointMake(point.x + _axis.sep / 2, point.y);
            }
            
            point = CGPointMake(point.x + size.width * _offSetRatio.x, point.y + size.height * _offSetRatio.y);
            
            [string drawAtPoint:point withAttributes:_paramStr];
        }
        
        [self.dictionaryString enumerateKeysAndObjectsUsingBlock:^(NSString * key, NSValue * obj, BOOL * stop) {
            
            CGSize size = [key sizeWithAttributes:_paramStr];
            CGPoint over_pt = GGPerpendicularMake(_axis.line, obj.CGPointValue, _axis.over);
            CGPoint point = CGPointMake(over_pt.x + size.width * _offSetRatio.x, over_pt.y + size.height * _offSetRatio.y);
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
            point = CGPointMake(point.x + size.width * _offSetRatio.x, point.y + size.height * _offSetRatio.y);
            [string drawAtPoint:point withAttributes:_paramStr];
        }
        
        UIGraphicsPopContext();
    }
}

GGLazyGetMethod(NSMutableDictionary, dictionaryString);

@end
