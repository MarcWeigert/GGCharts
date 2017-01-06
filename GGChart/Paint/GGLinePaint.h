//
//  GGLineBrush.h
//  HSCharts
//
//  Created by 黄舜 on 16/12/29.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGDrawerProtocol.h"
#import "GGLayer.h"

@interface GGLinePaint : NSObject <GGLayerProtocal>

@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIColor *color;

/** 初始化 */
+ (instancetype)lineBrushWithLine:(id <GGPointProtocol>)line;
+ (instancetype)lineBrushWithFrom:(CGPoint)from to:(CGPoint)to;

@end
