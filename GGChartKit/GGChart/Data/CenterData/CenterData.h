//
//  CenterData.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/21.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NumberData.h"
#import "CenterAbstract.h"

@interface CenterLableData : NumberData <CenterLableAbstract>

/**
 * 中间数字
 */
@property (nonatomic, assign) CGFloat number;

/**
 * 富文本字符串
 */
@property (nonatomic, copy) NSAttributedString *(^attrbuteStringValueBlock)(CGFloat value);

@end

@interface CenterData : NSObject <CenterAbstract>

/**
 * 填充颜色
 */
@property (nonatomic, strong) UIColor * fillColor;

/**
 * 结构体
 */
@property (nonatomic, assign) CGFloat radius;

/**
 * 中间文字配置
 */
@property (nonatomic, strong) CenterLableData * lable;

/**
 * 折线图更新数据, 绘制前配置
 */
- (void)updateCenterConfigs:(CGRect)rect;

@end
