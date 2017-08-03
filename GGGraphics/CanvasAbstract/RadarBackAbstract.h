//
//  RadarBackAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/1.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef RadarBackAbstract_h
#define RadarBackAbstract_h

@protocol RadarBackAbstract <NSObject>

@property (nonatomic, strong) NSArray <NSString *> * titles;

@property (nonatomic, strong) UIColor * strockColor;

@property (nonatomic, assign) NSUInteger splitCount;

@property (nonatomic, strong) UIFont * titleFont;

@property (nonatomic, assign) CGFloat lineWidth;

@property (nonatomic, assign) CGFloat radius;

@property (nonatomic, assign, readonly) NSInteger side;

@end


#endif /* RadarBackAbstract_h */
