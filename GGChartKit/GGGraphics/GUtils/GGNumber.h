//
//  GGNumber.h
//  GGCharts
//
//  Created by 黄舜 on 2017/11/24.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGNumber : NSObject <NSCopying>

@property (readonly) float floatValue;

@property (readonly) double doubleValue;

+ (GGNumber *)numberWithFloat:(float)value;

+ (GGNumber *)numberWithDouble:(double)value;

@end
