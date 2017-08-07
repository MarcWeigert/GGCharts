//
//  GGLineData.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    ScalerAxisLeft = 0,
    ScalerAxisRight,
} ScalerAxisType;

@interface GGLineData : NSObject

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) UIColor * lineColor;

@property (nonatomic, assign) CGFloat shapeRadius;

@property (nonatomic, strong) UIColor * shapeFillColor;

@property (nonatomic, strong) UIFont * stringFont;

@property (nonatomic, strong) NSString * dataFormatter;

@property (nonatomic, strong, readonly) DLineScaler * lineScaler;

@property (nonatomic, assign) NSArray <NSNumber *> *lineDataAry;

@property (nonatomic, assign) ScalerAxisType scalerType;

@property (nonatomic, strong) NSNumber * fillRoundPrice;        ///< 环绕填价格点(默认最小值DataSet)

@property (nonatomic, strong) UIColor * lineFillColor;

@end
