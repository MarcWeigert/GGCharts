//
//  PieChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseCountChart.h"
#import "PieData.h"

@interface PieChart : BaseCountChart

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, strong) NSArray <PieData *> *dataAry;

@property (nonatomic, copy) UIFont * titleFont;
@property (nonatomic, copy) UIFont * perFont;
@property (nonatomic, copy) NSString * attachedString;

@property (nonatomic, copy) NSString * format;

- (void)addAnimationWithDuration:(NSTimeInterval)duration;

@end
