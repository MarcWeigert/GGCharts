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

@interface GGStringRenderer : NSObject

@property (nonatomic) NSArray * aryStr;

@property (nonatomic) UIFont * font;

@property (nonatomic) UIColor * color;

+ (instancetype)stringForAxis:(GGAxis)axis;

+ (instancetype)stringForCGPath:(CGPathRef)ref;

@end
