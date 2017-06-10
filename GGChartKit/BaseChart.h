//
//  BaseChart.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGCanvas.h"
#import "GGShapeCanvas.h"

#define ChartShape(A)         [self getShapeWithTag:A]
#define ChartBack(A)          [self getCanvasWithTag:A]
#define ChartPie(A)           [self getPieWithTag:A]

@interface BaseChart : UIView

- (GGCanvas *)getCanvasWithTag:(NSInteger)tag;

- (GGShapeCanvas *)getShapeWithTag:(NSInteger)tag;

- (GGShapeCanvas *)getPieWithTag:(NSInteger)tag;

@end
