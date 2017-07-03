//
//  BaseCountChart.h
//  HSCharts
//
//  Created by _ | Durex on 2017/6/23.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChart.h"
#import "UICountingLabel.h"

@interface BaseCountChart : BaseChart

@property (nonatomic, strong) NSMutableArray <UICountingLabel *> * visibleLables;      ///< 显示的图层

/**
 * 取图层视图大小与Chart一致
 */
- (UICountingLabel *)getGGCountLable;

@end
