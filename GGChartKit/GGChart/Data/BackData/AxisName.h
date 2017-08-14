//
//  AxisName.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/14.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AxisAbstract.h"

@interface AxisName : NSObject <AxisTitleAbstract>

@property (nonatomic, strong) NSString * string;    ///< 文字
@property (nonatomic, strong) UIFont * font;        ///< 字体
@property (nonatomic, strong) UIColor * color;      ///< 文字颜色

@property (nonatomic, assign) CGFloat offsetOfEndPoint;     ///< 轴偏移距离
@property (nonatomic, assign) CGPoint offsetRatio;      ///< 围绕中心点偏移文字距离
@property (nonatomic, assign) CGSize offsetSize;        ///< 文字偏移

@end
