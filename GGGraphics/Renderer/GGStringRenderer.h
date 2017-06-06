//
//  GGStringRenderer.h
//  111
//
//  Created by _ | Durex on 2017/6/4.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"

@interface GGStringRenderer : NSObject <GGRenderProtocol>

@property (nonatomic) UIFont * font;

@property (nonatomic) UIColor * color;

@property (nonatomic) CGSize offset;

+ (instancetype)stringForAxis:(GGAxis)axis aryStr:(NSArray *)aryStr;

+ (instancetype)stringForCGPath:(CGPathRef)ref aryStr:(NSArray *)aryStr;

+ (instancetype)stringForPoint:(CGPoint)point string:(NSString *)string;

@end
