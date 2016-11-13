//
//  BaseBrush.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BaseBrush : NSObject

@property (nonatomic, readonly, weak) NSMutableArray *array;    ///< 存放block

@property (nonatomic, readonly) CGRect drawFrame;

/** 初始化绘制区域 */
- (id)initWithArray:(NSMutableArray *)muAry drawFrame:(CGRect)frame;

/** 构造绘制函数 */
- (void (^)())draw;

@end
