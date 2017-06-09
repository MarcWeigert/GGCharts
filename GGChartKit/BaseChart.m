//
//  BaseChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/8.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BaseChart.h"

#define GGLazyGetMethod(type, attribute)            \
- (type *)attribute                                 \
{                                                   \
    if (!_##attribute) {                            \
        _##attribute = [[type alloc] init];         \
    }                                               \
    return _##attribute;                            \
}

#define Layer_Key    [NSString stringWithFormat:@"%zd", tag]

@interface BaseChart ()

@property (nonatomic) NSMutableDictionary * lineLayerDictionary;

@property (nonatomic) NSMutableDictionary * pieLayerDictionary;

@end

@implementation BaseChart

- (GGCanvas *)getCanvasWithTag:(NSInteger)tag
{
    GGCanvas * layer = [self.lineLayerDictionary objectForKey:Layer_Key];
    
    if (!layer) {
        
        layer = [[GGCanvas alloc] init];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:layer];
    }
        
    return layer;
}

- (GGShapeCanvas *)getShapeWithTag:(NSInteger)tag
{
    GGShapeCanvas * layer = [self.lineLayerDictionary objectForKey:Layer_Key];
    
    if (!layer) {
        
        layer = [[GGShapeCanvas alloc] init];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:layer];
        [self.lineLayerDictionary setObject:layer forKey:Layer_Key];
    }
    
    return layer;
}

- (GGShapeCanvas *)getPieWithTag:(NSInteger)tag
{
    GGShapeCanvas * layer = [self.lineLayerDictionary objectForKey:Layer_Key];
    
    if (!layer) {
        
        CGFloat width = self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
        CGFloat x = (self.frame.size.width - width) / 2;
        CGFloat y = (self.frame.size.height - width) / 2;
        
        layer = [[GGShapeCanvas alloc] init];
        layer.frame = CGRectMake(x, y, width, width);
        [self.layer addSublayer:layer];
        [self.pieLayerDictionary setObject:layer forKey:Layer_Key];
    }
    
    return layer;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self.lineLayerDictionary enumerateKeysAndObjectsUsingBlock:^(id key, CALayer * obj, BOOL * stop) {
        
        obj.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
    
    [self.pieLayerDictionary enumerateKeysAndObjectsUsingBlock:^(id key, CALayer * obj, BOOL * stop) {
        
        CGFloat width = self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
        CGFloat x = (self.frame.size.width - width) / 2;
        CGFloat y = (self.frame.size.height - width) / 2;
        
        obj.frame = CGRectMake(x, y, width, width);
    }];
}

#pragma mark - Lazy

GGLazyGetMethod(NSMutableDictionary, lineLayerDictionary);

GGLazyGetMethod(NSMutableDictionary, pieLayerDictionary);

@end
