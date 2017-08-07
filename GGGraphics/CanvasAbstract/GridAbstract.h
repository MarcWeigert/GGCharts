//
//  GridAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef GridAbstract_h
#define GridAbstract_h

#import "AxisAbstract.h"

@protocol GridAbstract <NSObject>

@property (nonatomic, assign) CGFloat gridLineWidth;

@property (nonatomic, assign) UIColor * gridColor;

@property (nonatomic, assign) UIEdgeInsets insets;

@property (nonatomic, assign, readonly) NSArray <id <AxisAbstract>> * axiss;

@end


#endif /* GridAbstract_h */
