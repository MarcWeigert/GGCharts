//
//  KTimeViewController.h
//  HSCharts
//
//  Created by _ | Durex on 17/6/26.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseModel.h"
#import "MinuteAbstract.h"
#import "VolumeAbstract.h"
#import "QueryViewAbstract.h"

@interface TimeModel : BaseModel <MinuteAbstract, VolumeAbstract, QueryViewAbstract>

@property (nonatomic , assign) NSInteger volume;
@property (nonatomic , assign) CGFloat price_change;
@property (nonatomic , assign) CGFloat price;
@property (nonatomic , assign) CGFloat price_change_rate;
@property (nonatomic , assign) CGFloat turnover;
@property (nonatomic , copy) NSString * date;
@property (nonatomic , assign) NSInteger total_volume;
@property (nonatomic , assign) CGFloat avg_price;
@property (nonatomic , strong) NSDate * ggDate;

@end

@interface KTimeViewController : UIViewController

@end
