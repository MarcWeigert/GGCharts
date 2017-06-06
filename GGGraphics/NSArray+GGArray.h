//
//  NSArray+GGArray.h
//  111
//
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GGChartGeometry.h"

@interface NSArray (GGArray)

- (void)lineChartScaler:(CGFloat (^)(CGFloat index))xScaler
                yScaler:(CGFloat (^)(CGFloat index))yScaler
        convertComplete:(void (^)(CGPoint *point, NSUInteger size))convert;

- (void)barChartScaler:(CGFloat (^)(CGFloat index))topScaler
          bottomScaler:(CGFloat (^)(CGFloat index))bottomScaler
               yScaler:(CGFloat (^)(CGFloat index))yScaler
       convertComplete:(void (^)(CGRect point, NSUInteger size))convert;

@end
