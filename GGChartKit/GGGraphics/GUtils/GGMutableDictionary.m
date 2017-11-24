//
//  GGMutableDictionary.m
//  GGCharts
//
//  Created by 黄舜 on 2017/11/24.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "GGMutableDictionary.h"

@interface GGMutableDictionary ()
@property NSMutableArray *array;
@property NSMutableDictionary *dictionary;
@end

@implementation GGMutableDictionary

- (instancetype)init {
    return [self initWithCapacity:10];
}

- (instancetype)initWithCapacity:(NSUInteger)capacity {
    if ((self = [super init])) {
        _array = [NSMutableArray arrayWithCapacity:capacity];
        _dictionary = [NSMutableDictionary dictionaryWithCapacity:capacity];
    }
    return self;
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    if ((self = [self initWithCapacity:10])) {
        [self addEntriesFromDictionary:dictionary];
    }
    return self;
}

+ (instancetype)dictionary {
    return [[self alloc] init];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    GGMutableDictionary *mutableCopy = [[GGMutableDictionary allocWithZone:zone] init];
    mutableCopy.array = [_array mutableCopy];
    mutableCopy.dictionary = [_dictionary mutableCopy];
    return mutableCopy;
}

- (instancetype)copy {
    return [self mutableCopy];
}

- (id)objectForKey:(id)key {
    return [_dictionary objectForKey:key];
}

- (void)setObject:(id)object forKey:(id)key {
    if (!object) {
        [self removeObjectForKey:key];
        return;
    }
    
    if (![_dictionary objectForKey:key]) {
        [_array addObject:key];
    }
    [_dictionary setObject:object forKey:key];
}

- (void)removeObjectForKey:(id)key {
    [_dictionary removeObjectForKey:key];
    [_array removeObject:key];
}

- (NSDictionary *)toDictionary {
    return [_dictionary copy];
}

- (void)sortUsingSelector:(SEL)selector {
    [_array sortUsingSelector:selector];
}

- (NSEnumerator *)keyEnumerator {
    return [_array objectEnumerator];
}

- (NSEnumerator *)reverseKeyEnumerator {
    return [_array reverseObjectEnumerator];
}

- (void)insertObject:(id)object forKey:(id)key atIndex:(NSUInteger)index {
    if ([_dictionary objectForKey:key]) {
        [self removeObjectForKey:key];
    }
    [_array insertObject:key atIndex:index];
    [self setObject:object forKey:key];
}

- (id)keyAtIndex:(NSUInteger)index {
    return [_array objectAtIndex:index];
}

- (void)setObject:(id)obj forKeyedSubscript:(id<NSCopying>)key {
    [self setObject:obj forKey:key];
}

- (id)objectForKeyedSubscript:(id)key {
    return [self objectForKey:key];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [_array countByEnumeratingWithState:state objects:buffer count:len];
}

- (void)sortKeysUsingSelector:(SEL)selector deepSort:(BOOL)deepSort {
    [_array sortUsingSelector:selector];
    
    if (deepSort) {
        for (id key in _array) {
            id value = self[key];
            if ([value respondsToSelector:@selector(sortKeysUsingSelector:deepSort:)]) {
                [value sortKeysUsingSelector:selector deepSort:deepSort];
            }
        }
    }
}

- (NSArray *)allKeys {
    return _array;
}

- (void)addEntriesFromDictionary:(NSDictionary *)dictionary {
    [_array addObjectsFromArray:[dictionary allKeys]];
    [_dictionary addEntriesFromDictionary:dictionary];
}

- (void)addObject:(id)object forKey:(id)key {
    NSMutableArray *values = self[key];
    if (!values) {
        values = [NSMutableArray array];
        self[key] = values;
    }
    [values addObject:object];
}

- (NSString *)description {
    NSMutableArray *lines = [NSMutableArray array];
    [lines addObject:@"{"];
    for (id key in self) {
        [lines addObject:[NSString stringWithFormat:@"  %@: %@", key, self[key]]];
    }
    [lines addObject:@"}"];
    return [lines componentsJoinedByString:@"\n"];
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[GGMutableDictionary class]]) {
        GGMutableDictionary *dict = (GGMutableDictionary *)object;
        return [[dict toDictionary] isEqual:_dictionary] && [[dict allKeys] isEqual:[self allKeys]];
    }
    return NO;
}

- (NSUInteger)hash {
    return [_dictionary hash];
}

@end
