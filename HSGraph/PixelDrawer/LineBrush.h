//
//  LineBrush.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "BaseBrush.h"

@interface LineBrush : BaseBrush

- (LineBrush *(^)(CGPoint from))from;

- (LineBrush *(^)(CGPoint to))to;

- (LineBrush *(^)(CGPoint from, CGPoint to))line;

- (LineBrush *(^)(CGPoint offset))offset;

- (LineBrush *(^)(CGFloat x))x;

- (LineBrush *(^)(CGFloat y))y;

- (LineBrush *(^)(CGFloat))width;

- (LineBrush *(^)(UIColor *))color;

@end
