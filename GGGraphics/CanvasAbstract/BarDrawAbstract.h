//
//  BarDrawAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef BarDrawAbstract_h
#define BarDrawAbstract_h

#import "DBarScaler.h"

@protocol BarDrawAbstract <NSObject>

@property (nonatomic, strong, readonly) DBarScaler * barScaler;

@property (nonatomic, strong) UIColor * barColor;

@property (nonatomic, strong) UIColor * shapeFillColor;

@property (nonatomic, strong) UIFont * stringFont;

@property (nonatomic, strong) UIColor * stringColor;

@property (nonatomic, strong) NSString * dataFormatter;

@property (nonatomic, strong) UIColor * lineFillColor;

@end

#endif /* BarDrawAbstract_h */
