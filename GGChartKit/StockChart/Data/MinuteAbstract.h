//
//  MinuteAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/5.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef MinuteAbstract_h
#define MinuteAbstract_h

@protocol MinuteAbstract <NSObject>

- (CGFloat)ggTimePrice;                 ///< 分时图价格

- (CGFloat)ggTimeAveragePrice;          ///< 分时图均价

- (CGFloat)ggTimeClosePrice;            ///< 分时图涨跌比率

- (NSDate *)ggTimeDate;            ///< 成交量标题

@end

#endif /* MinuteAbstract_h */
