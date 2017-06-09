//
//  BaseChartData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseChartData : NSObject

@property (nonatomic, strong) NSArray <NSNumber *>* dataSet;

- (void)getMax:(CGFloat *)max min:(CGFloat *)min;

+ (void)getChartDataAry:(NSArray *)dataAry max:(CGFloat *)max min:(CGFloat *)min;

+ (NSInteger)getMaxColum:(NSArray <BaseChartData *> *)array;

@end
