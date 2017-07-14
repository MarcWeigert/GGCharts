//
//  LoopScrollView.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/14.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LoopScrollView.h"
#import "GGChartDefine.h"

@interface LoopScrollView ()

@property (nonatomic, strong) NSMutableArray <NSString *> * identifiers;
@property (nonatomic, strong) NSMutableDictionary <NSString *, Class> * dictionarySubLayerClazz;

@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet *> * dictionaryVisible;
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSMutableSet *> * dictionaryInvisible;

@end

@implementation LoopScrollView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [self registerObservers];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self registerObservers];
    }
    
    return self;
}

#pragma mark - 监听移入移出

/** 获取显示的视图 */
- (CALayer *)getVisibleLayerWithIdentifier:(NSString *)identifier
{
    id layer = [[self.dictionaryInvisible objectForKey:identifier] anyObject];
    
    if (!layer) {
        
        layer = [[self.dictionarySubLayerClazz objectForKey:identifier] new];
        [self.layer addSublayer:layer];
    }
    
    [[self.dictionaryVisible objectForKey:identifier] addObject:layer];
    [[self.dictionaryInvisible objectForKey:identifier] removeObject:layer];
    
    return layer;
}

/** 移除显示的视图 */
- (void)removeLayer:(CALayer *)layer withIdentifier:(NSString *)identifier
{
    [[self.dictionaryInvisible objectForKey:identifier] addObject:layer];
    [[self.dictionaryVisible objectForKey:identifier] removeObject:layer];

}

- (void)contentSizeChangeSubLayersMove:(CGPoint)contentOffset
{
    ;
}

#pragma mark - 注册KVO监听

- (void)registerObservers
{
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [self addObserver:self forKeyPath:@"contentOffset" options:options context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        NSLog(@"x : %.2f, y : %.2f", self.contentOffset.x, self.contentOffset.y);
    }
}

#pragma mark - 注册层数据

/** 注册layer */
- (void)registerLayerClass:(Class)layerClass forLayerReuseIdentifier:(NSString *)identifier
{
    [self.identifiers addObject:identifier];
    [self.dictionarySubLayerClazz setValue:layerClass forKey:identifier];
    [self.dictionaryVisible setValue:[NSMutableSet new] forKey:identifier];
    [self.dictionaryInvisible setValue:[NSMutableSet new] forKey:identifier];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.identifiers enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        
        if (![[self.dictionaryVisible objectForKey:obj] count]) {
            
            CALayer *layer = [self getVisibleLayerWithIdentifier:obj];
            layer.gg_size = self.gg_size;
        }
    }];
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, identifiers);
GGLazyGetMethod(NSMutableDictionary, dictionarySubLayerClazz);
GGLazyGetMethod(NSMutableDictionary, dictionaryVisible);
GGLazyGetMethod(NSMutableDictionary, dictionaryInvisible);

@end
