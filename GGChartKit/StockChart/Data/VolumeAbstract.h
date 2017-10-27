//
//  VolumeAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef VolumeAbstract_h
#define VolumeAbstract_h

@protocol VolumeAbstract <NSObject>

- (CGFloat)ggVolume;                    ///< 成交量

- (NSDate *)ggVolumeDate;            ///< 成交量标题

@end

#endif /* VolumeAbstract_h */
