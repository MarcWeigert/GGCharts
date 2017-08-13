//
//  BarCanvasAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef BarCanvasAbstract_h
#define BarCanvasAbstract_h

#import "BarDrawAbstract.h"

@protocol BarCanvasAbstract <NSObject>

@property (nonatomic, assign, readonly) UIEdgeInsets lineInsets;

@property (nonatomic, assign) BOOL isGroupingAlignment;     ///< 是否分组排列

@property (nonatomic, copy) UIColor *(^barColorsAtIndexPath)(NSIndexPath *indexPath);   ///< 颜色

@property (nonatomic, strong) NSArray <id <BarDrawAbstract>> *aryBars;  ///< 数组

@end

#endif /* BarCanvasAbstract_h */
