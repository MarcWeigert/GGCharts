//
//  TextBrush.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "TextBrush.h"

@interface TextBrush ()

@property (nonatomic) UIFont *tFont;

@property (nonatomic) UIColor *tColor;

@property (nonatomic) CGPoint tCenter;

@property (nonatomic) NSString *str;

@property (nonatomic) T_DRAW drawType;

@end

@implementation TextBrush

- (id)initWithArray:(NSMutableArray *)muAry drawFrame:(CGRect)frame
{
    self = [super initWithArray:muAry drawFrame:frame];
    
    if (self) {
        
        _drawType = T_CENTER;
        _tFont = [UIFont systemFontOfSize:10];
        _tColor = [UIColor blackColor];
        _str = @"";
    }
    
    return self;
}   

#pragma mark 属性设置

- (TextBrush *(^)(NSString *text))text
{
    return ^(NSString *text) {
    
        _str = text;
        
        return self;
    };
}

- (TextBrush *(^)(CGPoint center))point
{
    return ^(CGPoint center) {
    
        _tCenter = center;
        
        return self;
    };
}

- (TextBrush *(^)(CGPoint offset))offset
{
    return ^(CGPoint offset) {
    
        _tCenter = CGPointMake(_tCenter.x + offset.x, _tCenter.y + offset.y);
        
        return self;
    };
}

- (TextBrush *(^)(CGFloat x))x
{
    return ^(CGFloat x) {
    
        _tCenter = CGPointMake(_tCenter.x + x, _tCenter.y);
        
        return self;
    };
}

- (TextBrush *(^)(CGFloat y))y
{
    return ^(CGFloat y) {
    
        _tCenter = CGPointMake(_tCenter.x, _tCenter.y + y);
        
        return self;
    };
}

- (TextBrush *(^)(T_DRAW drawType))type
{
    return ^(T_DRAW drawType) {
    
        _drawType = drawType;
        
        return self;
    };
}

- (TextBrush *(^)(UIFont *))font
{
    return ^(UIFont *font) {
    
        _tFont = font;
        
        return self;
    };
}

- (TextBrush *(^)(UIColor *))color
{
    return ^(UIColor *color) {
    
        _tColor = color;
        
        return self;
    };
}

#pragma mark - 绘制

- (CGRect)drawRect
{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_tFont, NSFontAttributeName, _tColor, NSForegroundColorAttributeName, nil];
    CGSize textSize = [_str sizeWithAttributes:dic];
    
    CGFloat x = _tCenter.x + self.drawFrame.origin.x;
    CGFloat y = _tCenter.y + self.drawFrame.origin.y;
    
    switch (_drawType) {
        case T_CENTER:
            return CGRectMake(x - textSize.width / 2, y - textSize.height / 2, textSize.width, textSize.height);
        case T_LEFT:
            return CGRectMake(x - textSize.width, y - textSize.height / 2, textSize.width, textSize.height);
        case T_RIGHT:
            return CGRectMake(x, y - textSize.height / 2, textSize.width, textSize.height);
        case T_UPPER:
            return CGRectMake(x - textSize.width / 2, y - textSize.height, textSize.width, textSize.height);
        case T_BOTTOM:
            return CGRectMake(x - textSize.width / 2, y, textSize.width, textSize.height);
        default:
            return CGRectMake(x - textSize.width / 2, y - textSize.height / 2, textSize.width, textSize.height);
    }
}

/** 构造绘制函数 */
- (void (^)())draw
{
    __weak UIColor *color = _tColor;
    __weak UIFont *font = _tFont;
    __weak NSString *text = _str;
    CGRect drawRect = [self drawRect];
    
    void (^drawBlock)(CGContextRef) = ^(CGContextRef context){
        
        UIGraphicsPushContext(context);
        NSDictionary *dic = @{NSFontAttributeName : font, NSForegroundColorAttributeName : color};
        [text drawInRect:drawRect withAttributes:dic];
        UIGraphicsPopContext();
    };
    
    return ^ {
    
        [self.array addObject:drawBlock];
    };
}

@end
