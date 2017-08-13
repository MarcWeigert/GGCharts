//
//  BarCanvas.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "BarCanvasAbstract.h"

@interface BarCanvas : GGCanvas

@property (nonatomic, strong) id <BarCanvasAbstract> barCanvas;

@end
