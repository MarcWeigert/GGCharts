//
//  NSNumber+GGNumber.m
//  GGCharts
//
//  Created by 黄舜 on 2017/11/24.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "NSNumber+GGNumber.h"

@implementation NSNumber (GGNumber)

- (NSUInteger)hash
{
    return abs(self.floatValue * 1000);
}

@end
