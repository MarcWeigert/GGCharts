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
#import "LineQueryData.h"
#import "XAxis.h"
#import "YAxis.h"

@class LineCanvas;

@interface LineDataSet : NSObject

@property (nonatomic, strong) NSArray <GGLineData *> * lineAry;

@property (nonatomic, strong) LineQueryData * lineQueryData;

@property (nonatomic, strong) XAxis * bottomAxis;
@property (nonatomic, strong) XAxis * topAxis;
@property (nonatomic, strong) YAxis * leftAxis;
@property (nonatomic, strong) YAxis * rightAxis;

@property (nonatomic, assign) CGFloat gridLineWidth;
@property (nonatomic, strong) UIColor * gridColor;
@property (nonatomic, assign) UIEdgeInsets insets;

@property (nonatomic, assign) BOOL isGroupingAlignment;     ///< 是否分组排列
@property (nonatomic, assign) BOOL isCenterAlignment;   ///< 是否居中排列

- (void)drawOnLineCanvas:(LineCanvas *)lineCanvas;

@end
