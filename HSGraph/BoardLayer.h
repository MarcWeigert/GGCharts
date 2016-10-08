//
//  SawBoard.h
//  HCharts
//
//  Created by 黄舜 on 16/6/23.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class PaintBrush;

@interface BoardLayer : CALayer

- (void)drawWithBrush:(PaintBrush *)brush;

@end
