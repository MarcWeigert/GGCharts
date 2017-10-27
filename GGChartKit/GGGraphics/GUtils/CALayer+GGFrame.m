//
//  CALayer+GGFrame.m
//  HSCharts
//
//  Created by _ | Durex on 17/6/22.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "CALayer+GGFrame.h"

@implementation CALayer (GGFrame)

- (CGFloat)gg_left {
    return self.frame.origin.x;
}

- (void)setGg_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)gg_top {
    return self.frame.origin.y;
}

- (void)setGg_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)gg_right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setGg_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)gg_bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setGg_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setGg_center:(CGPoint)gg_center
{
    CGRect frame = self.frame;
    frame.origin.x = gg_center.x - frame.size.width / 2;
    frame.origin.y = gg_center.y - frame.size.height / 2;
    self.frame = frame;
}

- (CGPoint)gg_center
{
    return CGPointMake(self.frame.origin.x + self.frame.size.width / 2, self.frame.origin.y + self.frame.size.height / 2);
}

- (CGFloat)gg_centerX {
    return self.gg_center.x;
}

- (void)setGg_centerX:(CGFloat)centerX {
    self.gg_center = CGPointMake(centerX, self.gg_center.y);
}

- (CGFloat)gg_centerY {
    return self.gg_center.y;
}

- (void)setGg_centerY:(CGFloat)centerY {
    self.gg_center = CGPointMake(self.gg_center.x, centerY);
}

- (CGFloat)gg_width {
    return self.frame.size.width;
}

- (void)setGg_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)gg_height {
    return self.frame.size.height;
}

- (void)setGg_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)gg_origin {
    return self.frame.origin;
}

- (void)setGg_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)gg_size {
    return self.frame.size;
}


- (void)setGg_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

@end
