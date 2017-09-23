//
//  CALayer+GGFrame.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (GGFrame)

@property (nonatomic) CGFloat gg_left;

@property (nonatomic) CGFloat gg_top;

@property (nonatomic) CGFloat gg_right;

@property (nonatomic) CGFloat gg_bottom;

@property (nonatomic) CGFloat gg_width;

@property (nonatomic) CGFloat gg_height;

@property (nonatomic) CGPoint gg_center;

@property (nonatomic) CGFloat gg_centerX;

@property (nonatomic) CGFloat gg_centerY;

@property (nonatomic) CGPoint gg_origin;

@property (nonatomic) CGSize gg_size;

@end
