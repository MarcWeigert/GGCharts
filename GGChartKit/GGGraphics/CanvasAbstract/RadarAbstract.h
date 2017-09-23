//
//  RadarAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef RadarAbstract_h
#define RadarAbstract_h

@protocol RadarAbstract <NSObject>

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, strong) UIColor *fillColor;

@property (nonatomic, strong) UIColor *strockColor;

@property (nonatomic, strong) NSArray <NSNumber *> *ratios;

#pragma mark - Gradient

@property (nonatomic, strong) NSArray * gradientColors;     ///< CGColor

@property (nonatomic, strong) NSArray <NSNumber *> *locations;

@end

#endif /* RadarAbstract_h */
