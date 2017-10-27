//
//  NSObject+FireBlock.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/3.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NSObject+FireBlock.h"

/**
 * 在主线程中执行block
 */
void runMainThreadWithBlock(Function block)
{
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            block();
        });
    }
    else {
        block();
    }
}

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
