//
//  LineBrush.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "BaseBrush.h"

@interface LineBrush : BaseBrush

- (LineBrush *(^)(FRAME_VERTICES))from;

- (LineBrush *(^)(FRAME_VERTICES))to;

- (LineBrush *(^)(CGFloat))leftset;

- (LineBrush *(^)(CGFloat))rightset;

- (LineBrush *(^)(CGFloat))upset;

- (LineBrush *(^)(CGFloat))downset;

- (LineBrush *(^)(CGFloat))width;

- (LineBrush *(^)(UIColor *))color;

@end
