//
//  CALayer+SawFrame.m
//  HCharts
//
//  Created by 黄舜 on 16/6/22.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "CALayer+SawFrame.h"

@implementation CALayer (SawFrame)

/** 左上角 */
- (CGPoint)topLeft
{
    return CGPointMake(self.left, self.top);
}

/** 右上角 */
- (CGPoint)topRight
{
    return CGPointMake(self.right, self.top);
}

/** 左下角 */
- (CGPoint)lowerLeft
{
    return CGPointMake(self.left, self.bottom);
}

/** 右下角 */
- (CGPoint)lowerRight
{
    return CGPointMake(self.right, self.bottom);
}

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

@end
