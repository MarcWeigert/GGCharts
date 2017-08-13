//
//  LineCanvas.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "LineCanvasAbstract.h"

@interface LineCanvas : GGCanvas

@property (nonatomic, strong) id <LineCanvasAbstract> lineDrawConfig;

- (void)startAnimation:(NSTimeInterval)duration;

@end
