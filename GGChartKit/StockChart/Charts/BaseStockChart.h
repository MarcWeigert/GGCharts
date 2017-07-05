//
//  BaseStockChart.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGraphics.h"

@interface BaseStockChart : UIView

@property (nonatomic, readonly) UIScrollView * scrollView;  ///< 滚动视图

@property (nonatomic, strong) DBarScaler * volumScaler;   ///< 成交量定标器

@property (nonatomic, strong) CAShapeLayer * redVolumLayer;   ///< 红色成交量
@property (nonatomic, strong) CAShapeLayer * greenVolumLayer;     ///< 绿色成交量

@property (nonatomic, strong, readonly) GGCanvas * kLineBackLayer;      ///< k线back
@property (nonatomic, strong, readonly) GGCanvas * stringLayer;      ///< k线back
@property (nonatomic, strong, readonly) UIScrollView * backScrollView;  ///< 背景滚动

- (void)scrollViewContentSizeDidChange:(NSDictionary *)change;

- (void)setVolumRect:(CGRect)rect;

- (BOOL)volumIsRed:(id)obj;

- (void)updateVolumLayer;

@end
