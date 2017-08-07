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

@property (nonatomic, assign) BOOL needShowGridLine;

@property (nonatomic, assign) BOOL needShowAxisLine;

@property (nonatomic, assign) CGFloat axisLineWidth;

@property (nonatomic, assign) CGPoint startLocalRatio;

@property (nonatomic, assign) CGPoint endLocalRatio;

@property (nonatomic, assign) CGPoint textRatio;

@property (nonatomic, assign) CGFloat over;

@end


#endif /* LeftAxisAbstract_h */
