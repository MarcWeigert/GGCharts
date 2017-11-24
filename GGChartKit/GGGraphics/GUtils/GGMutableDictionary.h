//
//  GGMutableDictionary.h
//  GGCharts
//
//  Created by 黄舜 on 2017/11/24.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GGMutableDictionary : NSObject <NSFastEnumeration>

@property (readonly) NSUInteger count;

- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
+ (instancetype)dictionary;

- (void)setObject:(id)object forKey:(id)key;
- (id)objectForKey:(id)key;

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key;
- (id)objectForKeyedSubscript:(id)key;

- (void)sortKeysUsingSelector:(SEL)selector deepSort:(BOOL)deepSort;
- (NSArray *)allKeys;

- (void)addEntriesFromDictionary:(NSDictionary *)dictionary;

- (NSEnumerator *)keyEnumerator;
- (NSEnumerator *)reverseKeyEnumerator;

- (NSDictionary *)toDictionary;

- (void)addObject:(id)object forKey:(id)key;

@end
