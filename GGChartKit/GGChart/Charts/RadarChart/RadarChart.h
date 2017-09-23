//
//  RadarChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RadarDataSet.h"
#import "RadarCanvas.h"

@interface RadarChart : UIView

@property (nonatomic, strong) RadarDataSet * radarData;

@property (nonatomic, strong, readonly) RadarCanvas * radarCanvas;

- (void)drawRadarChart;

@end
