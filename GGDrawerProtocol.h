//
//  GGDrawerProtocol.h
//  HSCharts
//
//  Created by 黄舜 on 16/12/30.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - GGPointProtocol

/** 点绘制对象 */
@protocol GGPointProtocol <NSObject>

/** 返回点数组 */
- (NSArray <NSValue *>*)linePoints;

@optional

/** 偏移量 */
- (void)x:(CGFloat)x;
- (void)y:(CGFloat)y;
- (void)offset:(CGPoint)offfset;

@end

#pragma mark - GGLayerProtocal

/** 画板接口 */
@protocol GGLayerProtocal <NSObject>

- (void (^)(CGContextRef))drawForContextRef;

@end
