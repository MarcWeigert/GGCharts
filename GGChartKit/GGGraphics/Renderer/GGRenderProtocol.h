//
//  GGRenderProtocol.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol GGRenderProtocol <NSObject>

/**
 * 绘制结构体
 */
- (void)drawInContext:(CGContextRef)ctx;

@optional

/**
 * 是否隐藏
 */
@property (nonatomic, assign) BOOL hidden;

@end
