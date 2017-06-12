//
//  CALayer+GGLayer.h
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface CALayer (GGLayer)

- (void)bringSublayerToFront:(CALayer *)layer;

- (void)sendSublayerToBack:(CALayer *)layer;

@end
