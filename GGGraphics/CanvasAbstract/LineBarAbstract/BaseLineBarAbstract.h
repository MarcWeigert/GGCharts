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


#pragma mark - 折线文字

/**
 * 折线文字字体
 */
@property (nonatomic, strong, readonly) UIFont * stringFont;

/**
 * 折线文字颜色
 */
@property (nonatomic, strong, readonly) UIColor * stringColor;

/**
 * 折线格式化字符串
 */
@property (nonatomic, strong, readonly) NSString * dataFormatter;

/**
 * 折线文字偏移比例
 *
 * {0, 0} 数据点左下方绘制, {-0.5, -0.5} 数据点中心绘制, {-1, -1} 数据点右上方绘制
 */
@property (nonatomic, assign, readonly) CGPoint offSetRatio;

/**
 * 折线文字偏移
 */
@property (nonatomic, assign, readonly) CGSize stringOffset;


@end

#endif /* BaseLineBarAbstract_h */
