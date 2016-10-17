//
//  VirginLayer.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class GraphLizard;

@interface VirginLayer : CALayer

@property (nonatomic, readonly) CGPoint gul;         ///< 左上角

@property (nonatomic, readonly) CGPoint gur;         ///< 右上角

@property (nonatomic, readonly) CGPoint gbl;         ///< 左下角

@property (nonatomic, readonly) CGPoint gbr;         ///< 右下角

@property (nonatomic, readonly) CGPoint gct;         ///< 中心

- (void)draw_updateFrame:(CGRect)frame lizard:(void (^) (GraphLizard *make))block;

@end
