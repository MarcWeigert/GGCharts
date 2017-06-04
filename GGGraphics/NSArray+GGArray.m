//
//  NSArray+GGArray.m
//  111
//
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "NSArray+GGArray.h"
#import "NSValue+GGValue.h"

@implementation NSArray (GGArray)

- (void)lineChartScaler:(CGFloat (^)(CGFloat index))xScaler
                yScaler:(CGFloat (^)(CGFloat index))yScaler
        convertComplete:(void (^)(CGPoint *point, NSUInteger size))convert
{
    CGPoint points[self.count];
    
    for (NSInteger i = 0; i < self.count; i++) {
        
        NSNumber * data = [self objectAtIndex:i];
        points[i] = CGPointMake(xScaler(i), yScaler(data.floatValue));
    }
    
    convert(points, self.count);
}

@end
