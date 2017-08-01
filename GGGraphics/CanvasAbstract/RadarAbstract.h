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

- (CGFloat)lineWidth;

- (UIColor *)fillColor;

- (UIColor *)strockColor;

- (NSArray <NSNumber *> *)datas;

@end

#endif /* RadarAbstract_h */
