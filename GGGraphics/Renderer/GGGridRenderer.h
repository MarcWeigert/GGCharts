//
//  GGGride.h
//  111
//
//  Created by _ | Durex on 2017/5/22.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGChart.h"

@interface GGGridRenderer : NSObject <GGRenderProtocol>

@property (nonatomic, strong) NSNumber * x_count;

@property (nonatomic, strong) NSNumber * y_count;

@property (nonatomic, assign) CGFloat width;

@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGSize dash;

@property (nonatomic, assign) GGGrid grid;

@end
