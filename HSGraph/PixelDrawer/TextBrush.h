//
//  TextBrush.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "BaseBrush.h"

typedef enum : NSUInteger {
    T_CENTER = 0,
    T_LEFT,
    T_RIGHT,
    T_UPPER,
    T_BOTTOM,
}T_DRAW;

@interface TextBrush : BaseBrush

- (TextBrush *(^)(NSString *text))text;

- (TextBrush *(^)(CGPoint center))point;

- (TextBrush *(^)(CGPoint offset))offset;

- (TextBrush *(^)(CGFloat x))x;

- (TextBrush *(^)(CGFloat y))y;

- (TextBrush *(^)(T_DRAW drawType))type;

- (TextBrush *(^)(UIFont *))font;

- (TextBrush *(^)(UIColor *))color;

@end
