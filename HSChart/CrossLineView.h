//
//  CrossLineView.h
//  HSCharts
//
//  Created by 黄舜 on 16/6/27.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CrossLineView : UIView

@property (nonatomic) NSArray <NSNumber *> *topAry;

@property (nonatomic) NSArray <NSNumber *> *bottomAry;

@property (nonatomic) UIColor *topLineColor;

@property (nonatomic) UIColor *bottomLineColor;

@property (nonatomic) UIColor *topFillColor;

@property (nonatomic) UIColor *bottomFillColor;

@property (nonatomic) NSArray *titleAry;

- (void)stockChart;

- (void)addAnimation;

@end
