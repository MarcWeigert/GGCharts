//
//  KLineData.h
//  GGCharts
//
//  Created by 黄舜 on 2017/10/27.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseModel.h"
#import "QueryViewAbstract.h"

@interface KLineData : BaseModel <KLineAbstract, VolumeAbstract, QueryViewAbstract>

@property (nonatomic , assign) CGFloat high_price;
@property (nonatomic , assign) CGFloat turnover;
@property (nonatomic , assign) CGFloat turnover_rate;
@property (nonatomic , assign) NSInteger volume;
@property (nonatomic , assign) CGFloat price_change;
@property (nonatomic , assign) CGFloat close_price;
@property (nonatomic , assign) CGFloat low_price;
@property (nonatomic , assign) CGFloat open_price;
@property (nonatomic , copy) NSString * date;
@property (nonatomic , assign) CGFloat amplitude;
@property (nonatomic , assign) CGFloat price_change_rate;

@property (nonatomic , assign) BOOL showTitle;
@property (nonatomic , copy) NSString * title;
@property (nonatomic , strong) NSDate * ggDate;

@end
