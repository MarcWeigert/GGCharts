//
//  LineCanvasAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef LineCanvasAbstract_h
#define LineCanvasAbstract_h

#import "BaseLineBarCanvasAbstract.h"
#import "LineDrawAbstract.h"

@protocol LineCanvasAbstract <BaseLineBarCanvasAbstract>

/**
 * 线内边距
 */
@property (nonatomic, assign, readonly) UIEdgeInsets insets;

/**
 * 线数据数组
 */
@property (nonatomic, strong) NSArray <id <LineDrawAbstract>> * lineAry;

@end

#endif /* LineCanvasAbstract_h */
