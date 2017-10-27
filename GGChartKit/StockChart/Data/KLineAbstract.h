//
//  KLineAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef KLineAbstract_h
#define KLineAbstract_h

@protocol KLineAbstract <NSObject>

- (CGFloat)ggOpen;                      ///< 开盘价

- (CGFloat)ggClose;                     ///< 收盘价

- (CGFloat)ggHigh;                      ///< 最高价

- (CGFloat)ggLow;                       ///< 最低价

- (NSDate *)ggKLineDate;                ///< k线时间

@end

#endif /* KLineAbstract_h */
