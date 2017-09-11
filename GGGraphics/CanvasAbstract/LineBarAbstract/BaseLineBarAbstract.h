//
//  BaseLineBarAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/11.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef BaseLineBarAbstract_h
#define BaseLineBarAbstract_h

@protocol BaseLineBarAbstract <NSObject>

/**
 * 用来显示的数据
 */
@property (nonatomic, strong, readonly) NSArray <NSNumber *> *dataAry;

/**
 * 绘制折线点
 */
@property (nonatomic, assign, readonly) CGPoint * points;

@end

#endif /* BaseLineBarAbstract_h */
