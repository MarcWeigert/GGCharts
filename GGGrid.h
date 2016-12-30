//
//  GGGrid.h
//  HSCharts
//
//  Created by 黄舜 on 16/12/30.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGDrawerProtocol.h"

@interface GGGrid : NSObject <GGLayerProtocal>

@property (nonatomic, assign) CGRect gridRect;

/** 增加一个绘制 */
- (void)addBrush:(id <GGLayerProtocal>)brush;

@end
