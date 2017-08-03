//
//  RadarIndicatorData.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

#define RardarIndicatorMake(title, maxs) [RadarIndicatorData indicatorWithTitle:title max:maxs]

@interface RadarIndicatorData : NSObject

@property (nonatomic, strong) NSString * title;    ///< 标题

@property (nonatomic, assign) CGFloat max;      ///< 最值

+ (RadarIndicatorData *)indicatorWithTitle:(NSString *)title max:(CGFloat)max;

@end
