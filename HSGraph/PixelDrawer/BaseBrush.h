//
//  BaseBrush.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FRAME_VERTICES) {
    up_left,                ///< 左上角
    up_right,               ///< 右上角
    low_left,               ///< 左下角
    low_right,              ///< 右下角
    center,                 ///< 中心点
};

@interface BaseBrush : NSObject

@property (nonatomic) CGRect frame;

@property (nonatomic, readonly, weak) NSMutableArray *array;    ///< 存放block

/** 初始化绘制区域 */
- (id)initWithFrame:(CGRect)frame array:(NSMutableArray *)muAry;

/** 构造绘制函数 */
- (void (^)())draw;

@end
