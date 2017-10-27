//
//  CenterAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef CenterAbstract_h
#define CenterAbstract_h

#import "NumberAbstract.h"

@protocol CenterLableAbstract <NumberAbstract>

/**
 * 中间数字
 */
@property (nonatomic, assign, readonly) CGFloat number;

@end

@protocol CenterAbstract <NSObject>

/**
 * 填充颜色
 */
@property (nonatomic, strong, readonly) UIColor * fillColor;

/**
 * 结构体
 */
@property (nonatomic, assign) GGPolygon polygon;

/**
 * 中间文字配置
 */
@property (nonatomic, strong, readonly) id <CenterLableAbstract> lable;

@end

#endif /* CenterAbstract_h */
