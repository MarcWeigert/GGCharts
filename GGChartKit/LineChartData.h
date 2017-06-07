//
//  LineChartData.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LineChartData : NSObject

@property (nonatomic, strong) NSString * lineName;
@property (nonatomic, strong) UIColor * lineColor;
@property (nonatomic, strong) NSArray <NSNumber *>* dataSet;

@end
