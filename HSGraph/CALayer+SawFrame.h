//
//  CALayer+SawFrame.h
//  HCharts
//
//  Created by 黄舜 on 16/6/22.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (SawFrame)

/** 左上角 */
- (CGPoint)topLeft;

/** 右上角 */
- (CGPoint)topRight;

/** 左下角 */
- (CGPoint)lowerLeft;

/** 右下角 */
- (CGPoint)lowerRight;

/** 左边 */
- (CGFloat)left;

/** 右边 */
- (CGFloat)right;

/** 顶部 */
- (CGFloat)top;

/** 底部 */
- (CGFloat)bottom;

/** 宽 */
- (CGFloat)width;

/** 高 */
- (CGFloat)height;

@end
