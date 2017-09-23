//
//  GridBackCanvas.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "GridAbstract.h"

@interface GridBackCanvas : GGCanvas

/**
 * 配置接口类
 */
@property (nonatomic, strong) id <GridAbstract> gridDrawConfig;

@end
