//
//  LineDrawAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef LineDrawAbstract_h
#define LineDrawAbstract_h

#import "DLineScaler.h"

@protocol LineDrawAbstract <NSObject>

@property (nonatomic, strong, readonly) DLineScaler * lineScaler;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) UIColor * lineColor;

@property (nonatomic, assign) CGFloat shapeRadius;

@property (nonatomic, strong) UIColor * shapeFillColor;

@property (nonatomic, strong) UIFont * stringFont;

@property (nonatomic, strong) NSString * dataFormatter;

@property (nonatomic, strong) NSNumber * fillRoundPrice;

@property (nonatomic, strong) UIColor * lineFillColor;

@end

#endif /* LineDrawAbstract_h */
