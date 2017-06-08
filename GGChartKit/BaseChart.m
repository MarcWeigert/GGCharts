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

@property (nonatomic) NSMutableSet * visibleCanvas;
@property (nonatomic) NSMutableSet * availableCanvas;

@property (nonatomic) NSMutableSet * visibleShapeCanvas;
@property (nonatomic) NSMutableSet * availableShapeCanvas;

@property (nonatomic) NSMutableDictionary * layerDictionary;

@end

@implementation BaseChart

- (GGCanvas *)getCanvasWithTag:(NSInteger)tag
{
    GGCanvas * layer = [self.layerDictionary objectForKey:Layer_Key];
    
    if (!layer) {
        
        layer = [[GGCanvas alloc] init];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:layer];
    }
        
    return layer;
}

- (GGShapeCanvas *)getShapeWithTag:(NSInteger)tag
{
    GGShapeCanvas * layer = [self.layerDictionary objectForKey:Layer_Key];
    
    if (!layer) {
        
        layer = [[GGShapeCanvas alloc] init];
        layer.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [self.layer addSublayer:layer];
        [self.layerDictionary setObject:layer forKey:Layer_Key];
    }
    
    return layer;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    [self.layerDictionary enumerateKeysAndObjectsUsingBlock:^(id key, CALayer * obj, BOOL * stop) {
        
         obj.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    }];
}


#pragma mark - Lazy

GGLazyGetMethod(NSMutableDictionary, layerDictionary);

@end
