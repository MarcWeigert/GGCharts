//
//  StockModelProtocal.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol TimeDataProtocol <NSObject>

- (CGFloat)ggTimePrice;                 ///< 分时图价格

- (CGFloat)ggTimeAveragePrice;          ///< 分时图均价

- (CGFloat)ggTimeClosePrice;            ///< 分时图涨跌比率

- (NSDate *)ggTimeDate;                 ///< 分时图日期

- (NSString *)ggTimeFormatter;          ///< 分时图日期格式化

@end

@protocol VolumeDataProtocol <NSObject>

- (CGFloat)ggVolume;                    ///< 成交量

- (NSDate *)ggVolumeDate;               ///< 成交量日期

- (NSString *)ggVolumeFormatter;        ///< 成交量日期格式化

@end

