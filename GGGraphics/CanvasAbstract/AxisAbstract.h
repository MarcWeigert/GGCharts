//
//  LeftAxisAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef LeftAxisAbstract_h
#define LeftAxisAbstract_h

@protocol AxisTitleAbstract <NSObject>

@property (nonatomic, strong) NSString * string;    ///< 文字
@property (nonatomic, strong) UIFont * font;        ///< 字体
@property (nonatomic, strong) UIColor * color;      ///< 文字颜色

@property (nonatomic, assign) CGFloat offsetOfEndPoint;     ///< 轴偏移距离
@property (nonatomic, assign) CGPoint offsetRatio;      ///< 围绕中心点偏移文字距离
@property (nonatomic, assign) CGSize offsetSize;        ///< 文字偏移

@end

@protocol AxisAbstract <NSObject>

@property (nonatomic, strong) UIFont * axisFont;
@property (nonatomic, strong) UIColor * axisColor;

@property (nonatomic, strong) UIColor * stringColor;
@property (nonatomic, strong) NSArray * titles;

@property (nonatomic, assign) BOOL drawStringAxisCenter;
@property (nonatomic, assign) BOOL needShowGridLine;
@property (nonatomic, assign) BOOL needShowAxisLine;

@property (nonatomic, assign) CGFloat axisLineWidth;
@property (nonatomic, assign) CGPoint startLocalRatio;
@property (nonatomic, assign) CGPoint endLocalRatio;
@property (nonatomic, assign) CGPoint textRatio;
@property (nonatomic, assign) CGFloat over;

@property (nonatomic, strong) NSArray <NSNumber *> *hiddenPattern;      ///< 隐藏文字
@property (nonatomic, assign) CGSize textOffset;        ///< 偏移量

@property (nonatomic, strong) id <AxisTitleAbstract> axisName;     ///< 轴

@end


#endif /* LeftAxisAbstract_h */
