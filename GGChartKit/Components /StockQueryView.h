//
//  StockQueryView.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryData : NSObject

@property (nonatomic, strong) NSString * key;
@property (nonatomic, strong) NSString * value;
@property (nonatomic, strong) UIColor * keyColor;
@property (nonatomic, strong) UIColor * valueColor;

@end

@interface StockQueryView : UIView

@property (nonatomic, strong) UIFont * textFont;
@property (nonatomic, assign) CGFloat interval;
@property (nonatomic, strong) NSArray <QueryData *> * aryData;
@property (nonatomic, assign) CGFloat width;

@property (nonatomic, readonly, assign) CGSize size;

@end
