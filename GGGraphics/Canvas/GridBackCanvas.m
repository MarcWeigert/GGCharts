//
//  GridBackCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GridBackCanvas.h"

@interface GridBackCanvas ()

@property (nonatomic, strong) GGAxisRenderer * leftAxisRenderer;
@property (nonatomic, strong) GGAxisRenderer * rightAxisRenderer;
@property (nonatomic, strong) GGAxisRenderer * topAxisRenderer;
@property (nonatomic, strong) GGAxisRenderer * bottomRenderer;

@property (nonatomic, strong) GGGridRenderer * gridRenderer;

@end

@implementation GridBackCanvas

#pragma mark - Lazy

GGLazyGetMethod(GGAxisRenderer, leftAxisRenderer);
GGLazyGetMethod(GGAxisRenderer, rightAxisRenderer);
GGLazyGetMethod(GGAxisRenderer, topAxisRenderer);
GGLazyGetMethod(GGAxisRenderer, bottomRenderer);

@end
