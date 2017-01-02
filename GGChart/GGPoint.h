//
//  GGLine.h
//  HSCharts
//
//  Created by 黄舜 on 16/12/29.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGDrawerProtocol.h"

/** 点对象 */
@interface GGPoint : NSObject <GGPointProtocol>

+ (instancetype)pointWithPoint:(CGPoint)point;

@end

/** 线对象 */
@interface GGLine : NSObject <GGPointProtocol>

+ (instancetype)lineWithFrom:(CGPoint)from to:(CGPoint)to;

@end

/** 折线对象 */
@interface GGMeanderLine : NSObject <GGPointProtocol>

+ (instancetype)meanderLineWithArray:(NSArray <NSValue *>*)array;

@end
