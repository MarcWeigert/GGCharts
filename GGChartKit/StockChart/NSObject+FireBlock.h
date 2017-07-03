//
//  NSObject+FireBlock.h
//  GGCharts
//
//  Created by 黄舜 on 17/7/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FireBlock)

/** 延时执行 */
- (void)performAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block;

@end
