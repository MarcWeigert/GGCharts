//
//  NumberData.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumberAbstract.h"

@interface NumberData : NSObject <NumberAbstract>

/**
 * 外部文字字体颜色
 */
@property (nonatomic, strong) UIColor * lableColor;

/**
 * 外部文字字体
 */
@property (nonatomic, strong) UIFont * lableFont;

/**
 * 扇形图内边文字格式化字符串
 */
@property (nonatomic, strong) NSString * stringFormat;

/**
 * 文字偏移比例
 */
@property (nonatomic, assign) CGPoint stringRatio;

/**
 * 文字偏移
 */
@property (nonatomic, assign) CGSize stringOffSet;

@end
