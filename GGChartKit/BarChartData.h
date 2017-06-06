//
//  BarChartData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BarChartData : NSObject

@property (nonatomic, strong) NSString * barName;
@property (nonatomic, strong) UIColor * barColor;
@property (nonatomic, strong) NSArray <NSNumber *>* dataSet;

@end
