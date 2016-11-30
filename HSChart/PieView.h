//
//  PieView.h
//  HSCharts
//
//  Created by 黄舜 on 16/11/29.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PieView : UIView

@property (nonatomic) NSArray *dataAry;

@property (nonatomic) NSArray *titleAry;

@property (nonatomic) NSArray *colorAry;

- (void)stockChart;

- (void)addAnimation;

@end
