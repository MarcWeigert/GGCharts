//
//  HollowFanView.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/13.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HollowFanView : UIView

@property (nonatomic) NSArray *dataAry;

@property (nonatomic) NSArray *titleAry;

@property (nonatomic) NSArray *colorAry;

- (void)stockChart;

- (void)addAnimation;

@end
