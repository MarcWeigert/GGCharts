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

@end

@implementation GGNumberRenderer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _param = [NSMutableDictionary dictionary];
    }
    
    return self;
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

- (void)drawInContext:(CGContextRef)ctx
{
    NSString * drawText = [NSString stringWithFormat:self.formatter, self.currentNumber];
    CGSize size = [drawText sizeWithAttributes:_param];
    CGPoint drawPoint = CGPointMake(self.currentPoint.x + size.width * _offSetRatio.x, self.currentPoint.y + size.height * _offSetRatio.y);
    UIGraphicsPushContext(ctx);
    [drawText drawAtPoint:drawPoint withAttributes:_param];
    UIGraphicsPopContext();
}

@end
