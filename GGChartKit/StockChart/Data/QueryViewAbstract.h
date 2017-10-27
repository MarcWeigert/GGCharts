//
//  QueryViewAbstract.h
//  GGCharts
//
//  Created by _ | Durex on 17/7/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef QueryViewAbstract_h
#define QueryViewAbstract_h

@protocol QueryViewAbstract <NSObject>

/** 
 * 查询Value颜色 
 *
 * @{@"key" : [UIColor redColor]}
 */
- (NSDictionary *)queryKeyForColor;

/** 
 * 查询Key颜色 
 *  
 * @{@"key" : [UIColor redColor]}
 */
- (NSDictionary *)queryValueForColor;

/**
 * 键值对 
 *
 * @[@{@"key" : @"value"},
 *   @{@"key" : @"value"},
 *   @{@"key" : @"value"}]
 */
- (NSArray <NSDictionary *> *)valueForKeyArray;

@end

#endif /* QueryViewAbstract_h */
