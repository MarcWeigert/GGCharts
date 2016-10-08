//
//  CumSumLineView.h
//  HSCharts
//
//  Created by 黄舜 on 16/6/28.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CumSumLineView : UIView

@property (nonatomic) NSArray *dataArys;

@property (nonatomic) NSArray *titleAry;

@property (nonatomic) NSArray *colorAry;

- (void)stockChart;

- (void)addAnimation;

@end
