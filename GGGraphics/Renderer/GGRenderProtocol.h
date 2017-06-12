//
//  GGRenderProtocol.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol GGRenderProtocol <NSObject>

- (void)drawInContext:(CGContextRef)ctx;

@optional

- (BOOL)hidden;

@end
