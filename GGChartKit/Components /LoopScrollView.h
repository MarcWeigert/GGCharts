//
//  LoopScrollView.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/14.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//
//  轮询滚动视图, 三张视图无限滚动
//

#import <UIKit/UIKit.h>
#import "GGGraphics.h"

@interface LoopScrollView : UIScrollView

/** 注册layer */
- (void)registerLayerClass:(Class)layerClass forLayerReuseIdentifier:(NSString *)identifier;

@end
