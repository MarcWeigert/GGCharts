//
//  KLineAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef KLineAbstract_h
#define KLineAbstract_h

@protocol KLineAbstract <NSObject>

- (CGFloat)ggOpen;                      ///< 开盘价

- (CGFloat)ggClose;                     ///< 收盘价

- (CGFloat)ggHigh;                      ///< 最高价

- (CGFloat)ggLow;                       ///< 最低价

- (BOOL)isShowTitle;                    ///< 是否显示标题

- (NSDate *)ggKLineDate;                ///< k线时间

- (NSString *)ggKLineTitle;             ///< 标题

@end

#endif /* KLineAbstract_h */
