//
//  MassChartData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChartData.h"

@interface MassChartData : BaseChartData

@property (nonatomic, assign) CGFloat value;

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) id attribute;

@property (nonatomic, assign) BOOL isKeyNote;

@property (nonatomic, assign) CGPoint dataPoint;

+ (void)masDataAry:(NSArray <MassChartData *> *)masAry max:(CGFloat *)max min:(CGFloat *)min;

@end
