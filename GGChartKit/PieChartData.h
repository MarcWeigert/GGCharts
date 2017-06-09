//
//  PieChartData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/9.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChartData.h"

@interface PieChartData : BaseChartData

@property (nonatomic, copy) NSString * pieName;

@property (nonatomic, copy) NSNumber * pieData;

@property (nonatomic, strong) UIColor * color;

+ (void)pieAry:(NSArray <PieChartData *>*)ary enumerateObjectsUsingBlock:(void(^)(CGFloat arc, CGFloat transArc, PieChartData * data))usingBlock;

@end
