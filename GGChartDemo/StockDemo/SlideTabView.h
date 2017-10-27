//
//  SlideTabView.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SwitchTabViewDelegate <NSObject>

@optional

- (void)tabBtnClicked:(NSInteger)btnTag;

@end

@interface SlideTabView : UIView

@property (nonatomic, assign) NSInteger tabCount;

@property (nonatomic, assign) NSInteger selectBtnIndex;

@property (nonatomic, weak) id<SwitchTabViewDelegate> delegate;

- (void)setSelectedBtn:(NSInteger)index;

+ (instancetype)switchTabView:(NSArray *)arrayTitles;

@end
