//
//  GGNumber.m
//  GGCharts
//
//  Created by 黄舜 on 2017/11/24.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGNumber.h"

@interface GGNumber()

@property (nonatomic, strong) NSNumber * number;

@end

@implementation GGNumber

- (id)copyWithZone:(NSZone *)zone
{
    GGNumber * number = [[GGNumber allocWithZone:zone] init];
    number.number = self.number;
    return number;
}

+ (GGNumber *)numberWithFloat:(float)value
{
    GGNumber * number = [GGNumber new];
    number.number = [NSNumber numberWithFloat:value];
    return number;
}

+ (GGNumber *)numberWithDouble:(double)value
{
    GGNumber * number = [GGNumber new];
    number.number = [NSNumber numberWithDouble:value];
    return number;
}

- (float)floatValue
{
    return _number.floatValue;
}

- (double)doubleValue
{
    return _number.doubleValue;
}

- (NSUInteger)hash
{
    NSInteger hash = (NSInteger)(_number.floatValue * 1000);
    
    NSLog(@"%zd", ABS(hash));
    
    return ABS(hash);
    
//    return (int)(f^(f >>> 32));
    
//    double d = sqrt(_number.floatValue);
//    unsigned char *p = (unsigned char *)&d;
//    return (NSUInteger)p;
}

- (BOOL)isEqual:(id)object
{
    return [_number isEqual:[object number]];
}

- (NSString *)description
{
    return _number.description;
}

- (NSString *)debugDescription
{
    return _number.debugDescription;
}

@end
