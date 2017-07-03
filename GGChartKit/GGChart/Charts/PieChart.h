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

@property (nonatomic, assign) CGFloat radius;       ///< 半径

@property (nonatomic, strong) NSArray <PieData *> *dataAry;     ///< 数据

@property (nonatomic, copy) UIFont * titleFont;     ///< 标题字体
@property (nonatomic, copy) UIFont * perFont;           ///< 比例字体
@property (nonatomic, copy) NSString * attachedString;      ///< 附加字符串

@property (nonatomic, copy) NSString * format;  ///< 数据格式化字符串

- (void)addAnimationWithDuration:(NSTimeInterval)duration;

@end
