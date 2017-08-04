//
//  GridBackCanvas.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "GridAbstract.h"
#import "AxisAbstract.h"

@interface GridBackCanvas : GGCanvas

@property (nonatomic, strong) id <GridAbstract> gridDrawConfig;

@end
