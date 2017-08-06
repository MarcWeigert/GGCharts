//
//  LineDataSet.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGLineData.h"
#import "GridAbstract.h"
#import "XAxis.h"
#import "YAxis.h"

@interface LineDataSet : NSObject <GridAbstract>

@property (nonatomic, strong) NSArray <GGLineData *> * lineAry;

@property (nonatomic, strong) XAxis * bottomAxis;
@property (nonatomic, strong) XAxis * topAxis;
@property (nonatomic, strong) YAxis * leftAxis;
@property (nonatomic, strong) YAxis * rightAxis;

@property (nonatomic, assign) CGFloat gridLineWidth;
@property (nonatomic, assign) UIColor * gridColor;
@property (nonatomic, assign) UIEdgeInsets insets;

@end
