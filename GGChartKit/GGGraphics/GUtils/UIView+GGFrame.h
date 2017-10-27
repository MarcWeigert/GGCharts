//
//  UIView+NIM.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (GGFrame)

@property (nonatomic) CGFloat gg_left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat gg_top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat gg_right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat gg_bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat gg_width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat gg_height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat gg_centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat gg_centerY;
/**
 * Shortcut for frame.origin
 */
@property (nonatomic) CGPoint gg_origin;

/**
 * Shortcut for frame.size
 */
@property (nonatomic) CGSize gg_size;

@end

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
