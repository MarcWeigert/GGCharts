//
//  LineQueryData.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LineQueryData : NSObject <QueryAbstract>

@property (nonatomic, assign) UIEdgeInsets insets;          ///< 查价框区域

@property (nonatomic, strong) UIColor * queryLineColor;     ///< 查价框颜色
@property (nonatomic, assign) CGFloat queryLineWidth;     ///< 查价框线宽

@property (nonatomic, assign) UIEdgeInsets queryTextInsets;     ///< 查价文字内边
@property (nonatomic, strong) UIColor * queryTextBackColor;     ///< 查价文字背景色
@property (nonatomic, strong) UIFont * queryTextFont;           ///< 查价文字字体

@end
