//
//  GraphSpider.h
//  HCharts
//
//  Created by 黄舜 on 16/6/16.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

@class LineShape;
@class BarShape;
@class RoundShape;

@interface GraphSpider : NSObject

@property (nonatomic, readonly) LineShape *drawLine;

@property (nonatomic, readonly) BarShape *drawBar;

@property (nonatomic, readonly) RoundShape *drawRound;

@property (nonatomic) BOOL updateLayers;

@property (nonatomic) BOOL removeLayers;

/** 传入视图 */
- (id)initWithLayer:(CALayer *)layer;

/** 绘制视图 */
- (NSArray *)stockShapeLayer;

@end
