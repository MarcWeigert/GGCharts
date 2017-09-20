//
//  PieCanvas.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "PieCanvasAbstract.h"

@interface PieCanvas : GGCanvas

@property (nonatomic, strong) id <PieCanvasAbstract> pieCanvasConfig;

@end
