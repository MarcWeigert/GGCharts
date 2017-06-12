//
//  GGCircle.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGRenderProtocol.h"
#import "GGChartGeometry.h"

@interface GGCircleRenderer : NSObject<GGRenderProtocol>

@property (nonatomic) GGCircle circle;

@property (nonatomic) CGFloat borderWidth;

@property (nonatomic) UIColor *fillColor;

@property (nonatomic) UIColor *borderColor;

@end
