//
//  NSObject+FireBlock.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NSObject+FireBlock.h"

@implementation NSObject (FireBlock)

- (void)fireBlockAfterDelay:(void (^)(void))block {
    
    block();
}

- (void)performAfterDelay:(NSTimeInterval)delay block:(void (^)(void))block
{
    [self performSelector:@selector(fireBlockAfterDelay:)
               withObject:block
               afterDelay:delay];
}

@end
