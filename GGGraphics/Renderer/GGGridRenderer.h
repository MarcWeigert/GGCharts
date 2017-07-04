//
//  GGGride.h
//  111
//
//  Created by _ | Durex on 2017/5/22.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "GGChartGeometry.h"
#import "GGRenderProtocol.h"

@interface GGGridRenderer : NSObject <GGRenderProtocol>

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGSize dash;

@property (nonatomic, assign) GGGrid grid;

@property (nonatomic, assign) BOOL isNeedRect;

@end
