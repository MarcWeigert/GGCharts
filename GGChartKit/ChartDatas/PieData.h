//
//  PieData.h
//  HSCharts
//
//  Created by _ | Durex on 2017/7/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChartData.h"
#import "GGShapeCanvas.h"

@interface PieData : BaseChartData

@property (nonatomic, copy) NSString * pieName;
@property (nonatomic, assign) CGFloat data;
@property (nonatomic, strong) UIColor * color;

@property (nonatomic, weak) GGShapeCanvas * shapeCanvas;
@property (nonatomic, weak) GGShapeCanvas * spiderCanvas;

@end
