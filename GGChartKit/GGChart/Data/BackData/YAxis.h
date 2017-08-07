//
//  YAxis.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AxisAbstract.h"

@interface YAxis : NSObject

@property (nonatomic, strong) NSNumber * max;

@property (nonatomic, strong) NSNumber * min;

@property (nonatomic, assign) NSInteger splitCount;

@property (nonatomic, strong) UIFont * axisFont;

@property (nonatomic, strong) UIColor * axisColor;

@property (nonatomic, assign) CGFloat axisLineWidth;

@property (nonatomic, assign) CGPoint textRatio;

@property (nonatomic, assign) CGFloat over;

@property (nonatomic, assign) BOOL needShowGridLine;

@property (nonatomic, assign) BOOL needShowAxisLine;

@property (nonatomic, assign) NSString * dataFormatter;

@end
