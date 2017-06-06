//
//  GGLine.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGRenderProtocol.h"
#import "ToolDefine.h"
#import "GGChartGeometry.h"

@interface GGLineRenderer : NSObject <GGRenderProtocol>

@property (nonatomic, assign) GGLine line;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor *color;

@end
