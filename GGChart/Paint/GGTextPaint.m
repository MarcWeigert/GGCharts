//
//  GGText.m
//  HSCharts
//
//  Created by 黄舜 on 16/12/30.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "GGTextPaint.h"

@interface GGTextPaint ()

@property (nonatomic, strong) NSArray <NSValue *>* pointAry;

@end

@implementation GGTextPaint

/** 初始化 */
+ (instancetype)textWithString:(NSString *)string point:(CGPoint)point
{
    GGTextPaint *text = [GGTextPaint new];
    text.texts = @[string];
    text.pointAry = @[[NSValue valueWithCGPoint:point]];
    return text;
}

+ (instancetype)textWithArray:(NSArray <NSString *>*) ary point:(id <GGPointProtocol>)point
{
    GGTextPaint *text = [GGTextPaint new];
    text.texts = ary;
    text.pointAry = [point linePoints];
    return text;
}

+ (instancetype)textWtihArray:(NSArray <NSString *>*)ary points:(NSArray <NSValue *>*)points
{
    GGTextPaint *text = [GGTextPaint new];
    text.texts = ary;
    text.pointAry = points;
    return text;
}

/** Setter */
- (void)setPoint:(id<GGPointProtocol>)point
{
    _pointAry = [point linePoints];
}

/** 计算文字绘制区域 */
- (CGRect)drawRectWithString:(NSString *)text point:(CGPoint)point
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_font, NSFontAttributeName, _color, NSForegroundColorAttributeName, nil];
    CGSize textSize = [text sizeWithAttributes:dic];
    
    CGFloat x = point.x;
    CGFloat y = point.y;
    
    switch (_direction) {
        case DRAW_CENTER:
            return CGRectMake(x - textSize.width / 2, y - textSize.height / 2, textSize.width, textSize.height);
        case DRAW_LEFT:
            return CGRectMake(x - textSize.width, y - textSize.height / 2, textSize.width, textSize.height);
        case DRAW_RIGHT:
            return CGRectMake(x, y - textSize.height / 2, textSize.width, textSize.height);
        case DRAW_UPPER:
            return CGRectMake(x - textSize.width / 2, y - textSize.height, textSize.width, textSize.height);
        case DRAW_BOTTOM:
            return CGRectMake(x - textSize.width / 2, y, textSize.width, textSize.height);
        default:
            return CGRectMake(x - textSize.width / 2, y - textSize.height / 2, textSize.width, textSize.height);
    }
}

/** 接口 */
- (void (^)(CGContextRef))drawForContextRef
{
    __block UIColor *color = _color;
    __block UIFont *font = _font;
    __block NSArray *pointAry = _pointAry;
    __block NSArray *strAry = _texts;
    __block typeof(self) weakSelf = self;
    
    return ^(CGContextRef context) {
    
        NSUInteger minCount = pointAry.count > strAry.count ? strAry.count : pointAry.count;
        
        for (NSInteger i = 0; i < minCount; i++) {
            
            NSString *string = strAry[i];
            CGPoint point = [pointAry[i] CGPointValue];
            CGRect drawRect = [weakSelf drawRectWithString:string point:point];
            
            UIGraphicsPushContext(context);
            NSDictionary *dic = @{NSFontAttributeName : font, NSForegroundColorAttributeName : color};
            [string drawInRect:drawRect withAttributes:dic];
            UIGraphicsPopContext();
        }
    };
}

@end
