//
//  GGRectRenderer.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGRenderProtocol.h"

@interface GGRectRenderer : NSObject <GGRenderProtocol>

@property (nonatomic, assign) CGRect rect;

@property (nonatomic, strong) UIColor * fillColor;

@end
