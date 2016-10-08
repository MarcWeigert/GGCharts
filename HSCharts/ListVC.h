//
//  ListVC.h
//  HCharts
//
//  Created by 黄舜 on 16/5/10.
//  Copyright © 2016年 黄舜. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListVC : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic) UITableView *table;

@end
