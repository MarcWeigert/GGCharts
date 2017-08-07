//
//  LineCanvasAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef LineCanvasAbstract_h
#define LineCanvasAbstract_h

#import "LineDrawAbstract.h"

@protocol LineCanvasAbstract <NSObject>

@property (nonatomic, assign, readonly) UIEdgeInsets lineInsets;

@property (nonatomic, assign) BOOL isGroupingAlignment;     ///< 是否分组排列

@property (nonatomic, assign) BOOL isCenterAlignment;   ///< 是否居中排列

@property (nonatomic, strong) NSArray <id <LineDrawAbstract>> * lineAry;

@end

#endif /* LineCanvasAbstract_h */
