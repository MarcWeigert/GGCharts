//
//  XAxis.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AxisAbstract.h"

@interface XAxis : NSObject <AxisAbstract>

@property (nonatomic, strong) UIFont * axisFont;

@property (nonatomic, strong) UIColor * axisColor;

@property (nonatomic, strong) NSArray * titles;

@property (nonatomic, assign) BOOL drawStringAxisCenter;

@property (nonatomic, assign) CGFloat axisLineWidth;

@property (nonatomic, assign) CGFloat textSpacing;

@end
