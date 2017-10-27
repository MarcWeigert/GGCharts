//
//  CrissCrossQueryView.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GGGraphics.h"
#import "QueryViewAbstract.h"

@interface QueryView : UIView

@property (nonatomic, strong) UIFont * textFont;    ///< 文字颜色
@property (nonatomic, assign) CGFloat interval;     ///< 间距
@property (nonatomic, assign) CGFloat width;        ///< 价格宽度
@property (nonatomic, strong) id <QueryViewAbstract> queryData;     ///< 显示数据

@property (nonatomic, readonly, assign) CGSize size;    ///< 大小

@end

@interface CrissCrossQueryView : UIView

@property (nonatomic, readonly) GGCanvas * cirssLayer;
@property (nonatomic, readonly) QueryView * queryView;

@property (nonatomic, assign) CGFloat yAxisOffsetX;     ///< 默认 frame.x
@property (nonatomic, assign) CGFloat xAxisOffsetY;     ///< 默认 frame.max_y - 10

@property (nonatomic, strong) UIColor * cirssLineColor;
@property (nonatomic, strong) UIColor * cirssLableColor;
@property (nonatomic, strong) UIColor * cirssLableBackColor;
@property (nonatomic, strong) UIFont * cirssLableFont;

@property (nonatomic, assign) CGFloat lineWidth;    ///< 线宽 默认 .5f

/** 设置中心点 */
- (void)setCenterPoint:(CGPoint)center;

- (void)setYString:(NSString *)ystring setXString:(NSString *)xString;

@end
