//
//  CenterCanvas.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGCanvas.h"
#import "CenterAbstract.h"

@interface CenterCanvas : GGCanvas

/**
 * 绘制类
 */
@property (nonatomic, strong) id <CenterAbstract> centerConfig;

@end
