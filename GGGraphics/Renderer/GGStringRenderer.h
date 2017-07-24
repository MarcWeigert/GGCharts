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

@property (nonatomic, strong) UIFont * font;
@property (nonatomic, strong) UIColor * color;
@property (nonatomic, assign) CGPoint point;
@property (nonatomic, assign) CGSize offset;
@property (nonatomic, assign) CGPoint offSetRatio;
@property (nonatomic, copy) NSString * string;
@property (nonatomic, strong) UIColor * fillColor;
@property (nonatomic, assign) UIEdgeInsets edgeInsets;

@end
