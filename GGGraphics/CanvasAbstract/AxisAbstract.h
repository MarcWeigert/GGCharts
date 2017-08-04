//
//  LeftAxisAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef LeftAxisAbstract_h
#define LeftAxisAbstract_h

@protocol AxisAbstract <NSObject>

@property (nonatomic, strong) UIFont * axisFont;

@property (nonatomic, strong) UIColor * axisColor;

@property (nonatomic, strong) NSArray * titles;

@property (nonatomic, assign) BOOL drawStringAxisCenter;

@property (nonatomic, assign) CGFloat axisLineWidth;

@property (nonatomic, assign) CGFloat textSpacing;

@property (nonatomic, assign, readonly) CGPoint localRatio;

@property (nonatomic, assign, readonly) CGPoint textRatio;

@end


#endif /* LeftAxisAbstract_h */
