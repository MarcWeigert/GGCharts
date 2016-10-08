//
//  ChartVC.m
//  HCharts
//
//  Created by 黄舜 on 16/5/10.
//  Copyright © 2016年 黄舜. All rights reserved.
//

#import "ChartVC.h"

@implementation ChartVC

- (id)initWithChartView:(UIView *)view
{
    self = [super init];
    
    if (self) {
        
        [self.view addSubview:view];
    }
    
    return self;
}

@end
