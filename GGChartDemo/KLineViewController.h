//
//  KLineViewController.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "KLineChart.h"
#import "QueryViewAbstract.h"
#import "KLineIndexManager.h"
#import "BaseIndexLayer.h"

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

@interface KLineViewController : UIViewController

@end
