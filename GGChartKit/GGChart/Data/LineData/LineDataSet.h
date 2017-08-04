//
//  LineDataSet.h
//  GGCharts
//
//  Created by 黄舜 on 17/8/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGLineData.h"

@interface LineDataSet : NSObject

@property (nonatomic, assign) UIEdgeInsets gridInside;

@property (nonatomic, strong) NSArray <GGLineData *> * lineAry;

@end
