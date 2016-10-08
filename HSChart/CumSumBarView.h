//
//  CumSumBarView.h
//  HSCharts
//
//  Created by 黄舜 on 16/6/24.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CumSumBarView : UIView

@property (nonatomic) NSArray *dataArys;

@property (nonatomic) NSArray *titleAry;

@property (nonatomic) NSArray *colorAry;

- (void)stockChart;

- (void)addAnimation;

@end
