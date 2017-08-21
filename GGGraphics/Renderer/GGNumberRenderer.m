//
//  GGNumberRenderer.m
//  GGCharts
//
//  Created by _ | Durex on 2017/8/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGNumberRenderer.h"

@interface GGNumberRenderer ()

@property (nonatomic, assign) CGFloat currentNumber;

@property (nonatomic, assign) CGPoint currentPoint;

@property (nonatomic, strong) NSMutableDictionary * param;

@property (nonatomic, assign) BOOL isIntValue;

@end

@implementation GGNumberRenderer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _param = [NSMutableDictionary dictionary];
        _format = @"%.2f";
        
        self.color = [UIColor blackColor];
        self.font = [UIFont systemFontOfSize:11];
    }
    
    return self;
}

/** 绘制起始点文字 */
- (void)drawAtToNumberAndPoint
{
    _currentNumber = _toNumber;
    _currentPoint = _toPoint;
}

/** 绘制终点文字 */
- (void)drawAtFromNumberAndPoint
{
    _currentNumber = _fromNumber;
    _currentPoint = _toPoint;
}

/** 更新 */
- (void)drawProgressNumberAndPoint:(CGFloat)progress
{
    _currentNumber = _fromNumber + (_toNumber - _fromNumber) * progress;
    
    GGLine line = GGPointLineMake(_fromPoint, _toPoint);
    line = GGLineMoveStart(line, GGLengthLine(line) * progress);
    _currentPoint = line.start;
}

- (void)startUpdateWithProgress:(CGFloat)progress
{
    _currentNumber = _fromNumber + (_toNumber - _fromNumber) * progress;
    
    GGLine line = GGPointLineMake(_fromPoint, _toPoint);
    line = GGLineMoveStart(line, GGLengthLine(line) * progress);
    _currentPoint = line.start;
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

- (void)setFormat:(NSString *)format
{
    _format = format;
    
    if([self.format rangeOfString:@"%(.*)d" options:NSRegularExpressionSearch].location != NSNotFound
       || [self.format rangeOfString:@"%(.*)i"].location != NSNotFound ) {
        
        _isIntValue = YES;
    }
    else {
        
        _isIntValue = NO;
    }
}

- (void)drawInContext:(CGContextRef)ctx
{
    if (self.hidden) { return; }
    
    NSString * drawText = _isIntValue ? [NSString stringWithFormat:self.format, (int)self.currentNumber] : [NSString stringWithFormat:self.format, self.currentNumber];
    CGSize size = [drawText sizeWithAttributes:_param];
    CGPoint drawPoint = CGPointMake(self.currentPoint.x + size.width * _offSetRatio.x, self.currentPoint.y + size.height * _offSetRatio.y);
    UIGraphicsPushContext(ctx);
    [drawText drawAtPoint:drawPoint withAttributes:_param];
    UIGraphicsPopContext();
}

@end
