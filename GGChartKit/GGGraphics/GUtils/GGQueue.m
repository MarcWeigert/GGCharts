//
//  GGQueue.m
//  GGCharts
//
//  Created by 黄舜 on 2017/11/24.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGQueue.h"
#import "GGMutableDictionary.h"

@interface GGQueue ()

/**
 * 区域
 */
@property (nonatomic, assign) NSRange range;

/**
 * 数据数组
 */
@property (nonatomic, strong) NSMutableDictionary * numCountHash;

@end

@implementation GGQueue

/**
 * 初始化
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _numCountHash = [NSMutableDictionary dictionary];
    }
    
    return self;
}

/**
 * 压如队列
 */
- (void)pushWithRange:(NSRange)range
{
    if (_range.location == 0 &&
        _range.length == 0) {
        
        for (int i = 0; i < range.length; i++) {
            
            [self push:i + range.location];
        }
    }
    else {
        
        NSInteger oldMaxLength = NSMaxRange(_range);
        NSInteger currentMaxLength = NSMaxRange(range);
        NSInteger popOrPushLocation = range.location - _range.location;
        NSInteger popOrPushLength = currentMaxLength -oldMaxLength;
        
        /**
         * 头压入压出队列
         */
        if (popOrPushLocation > 0) {
            
            for (NSInteger i = 0; i < ABS(popOrPushLocation); i++) {
                
                [self pop:range.location - i];
            }
        }
        else if (popOrPushLocation < 0) {
            
            for (NSInteger i = 0; i < ABS(popOrPushLocation); i++) {
                
                [self push:range.location + i];
            }
        }
        
        /**
         * 尾压入压出队列
         */
        if (popOrPushLength > 0) {
            
            for (NSInteger i = 0; i < ABS(popOrPushLength); i++) {
                
                [self push:currentMaxLength - i];
            }
        }
        else if (popOrPushLocation < 0) {
            
            for (NSInteger i = 0; i < ABS(popOrPushLocation); i++) {
                
                [self pop:currentMaxLength + i];
            }
        }
    }
    
    _range = range;
    
    NSLog(@"%@", _numCountHash);
    
    NSLog(@"--------------------%zd", _numCountHash.allKeys.count);
}

/**
 * 压入队列
 */
- (void)push:(NSInteger)index
{
    NSNumber * obj = @([_objArray[index] ggOpen]);
    NSNumber * countValue = _numCountHash[obj];
    NSInteger count = countValue.integerValue;
    
    [_numCountHash setObject:@(++count) forKey:obj];
}

/**
 * 取出队列
 */
- (void)pop:(NSInteger)index
{
    NSNumber * obj = @([_objArray[index] ggOpen]);
    NSNumber * countValue = _numCountHash[obj];
    NSInteger count = countValue.integerValue;
    --count;

    if (count <= 0) { [_numCountHash removeObjectForKey:obj]; }
    else { [_numCountHash setObject:@(count) forKey:obj]; }
}

/**
 * 极大值
 */
- (CGFloat)max
{
    return [_numCountHash.allKeys.lastObject floatValue];
}

/**
 * 极小值
 */
- (CGFloat)min
{
    return [_numCountHash.allKeys.firstObject floatValue];
}

@end
