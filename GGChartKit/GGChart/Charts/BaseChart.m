//
//  BaseChart.m
//  HSCharts
//
//  Created by _ | Durex on 17/6/8.
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

@property (nonatomic, strong) NSMutableArray <GGShapeCanvas *> * visibleLayers;      ///< 显示的图层
@property (nonatomic, strong) NSMutableArray <GGShapeCanvas *> * idleLayers;         ///< 闲置的图层

@property (nonatomic, strong) NSMutableArray <GGCanvas *> * visibleStaticLayers;      ///< 显示的图层
@property (nonatomic, strong) NSMutableArray <GGCanvas *> * idleStaticLayers;         ///< 闲置的图层

@end

@implementation BaseChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        UITapGestureRecognizer * recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapViewOnGesturer:)];
        [self addGestureRecognizer:recognizer];
        
        UIPanGestureRecognizer * swip = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(swipViewOnGesturer:)];
        [self addGestureRecognizer:swip];
    }
    
    return self;
}

- (void)tapViewOnGesturer:(UIGestureRecognizer *)recognizer
{
    [self onTapView:[recognizer locationInView:self]];
}

- (void)swipViewOnGesturer:(UIGestureRecognizer *)recognizer
{
    [self onPanView:[recognizer locationInView:self]];
}

/**
 * 手指轻触视图
 *
 * @param point 点击屏幕的点
 */
- (void)onTapView:(CGPoint)point
{

}

/**
 * 手指移动
 *
 * @param point 点击屏幕的点
 */
- (void)onPanView:(CGPoint)point
{

}

/**
 * 绘制图表(子类重写)
 */
- (void)drawChart
{
    [self.idleLayers addObjectsFromArray:self.visibleLayers];
    
    [self.visibleLayers enumerateObjectsUsingBlock:^(GGShapeCanvas * obj, NSUInteger idx, BOOL * stop) {
        
        [obj removeFromSuperlayer];
    }];
    
    [self.visibleLayers removeAllObjects];
    
    [self.idleStaticLayers addObjectsFromArray:self.visibleStaticLayers];
    
    [self.visibleStaticLayers enumerateObjectsUsingBlock:^(GGCanvas * obj, NSUInteger idx, BOOL * stop) {
        
        [obj removeFromSuperlayer];
    }];
    
    [self.visibleStaticLayers removeAllObjects];
}

/**
 * 取图层视图大小与Chart一致
 */
- (GGShapeCanvas *)getGGCanvasEqualFrame
{
    GGShapeCanvas * shape = [self makeOrGetShapeCanvas];
    shape.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:shape];
    [self.visibleLayers addObject:shape];
    return shape;
}

/**
 * 取图层视图大小为正方形
 */
- (GGShapeCanvas *)getGGCanvasSquareFrame
{
    CGFloat width = self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
    GGShapeCanvas * shape = [self makeOrGetShapeCanvas];
    shape.frame = CGRectMake(0, 0, width, width);
    shape.position = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    [self.layer addSublayer:shape];
    [self.visibleLayers addObject:shape];
    return shape;
}

/**
 * 获取图层
 */
- (GGShapeCanvas *)makeOrGetShapeCanvas
{
    GGShapeCanvas * shape = [self.idleLayers firstObject];
    
    if (shape == nil) {
        
        shape = [[GGShapeCanvas alloc] init];
    }
    else {
    
        [self.idleLayers removeObject:shape];
    }
    
    return shape;
}

/**
 * 获取图层
 */
- (GGCanvas *)makeOrGetStaticCanvas
{
    GGCanvas * canvas = [self.idleStaticLayers firstObject];
    
    if (canvas == nil) {
        
        canvas = [[GGCanvas alloc] init];
    }
    else {
        
        [self.idleStaticLayers removeObject:canvas];
    }
    
    return canvas;
}

/**
 * 取图层视图大小与Chart一致
 */
- (GGCanvas *)getGGStaticCanvasEqualFrame
{
    GGCanvas * canvas = [self makeOrGetStaticCanvas];
    canvas.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self.layer addSublayer:canvas];
    [self.visibleStaticLayers addObject:canvas];
    return canvas;
}

/**
 * 取图层视图大小为正方形
 */
- (GGCanvas *)getGGStaticCanvasSquareFrame
{
    CGFloat width = self.frame.size.width > self.frame.size.height ? self.frame.size.height : self.frame.size.width;
    GGCanvas * canvas = [self makeOrGetStaticCanvas];
    canvas.frame = CGRectMake(0, 0, width, width);
    [self.layer addSublayer:canvas];
    [self.visibleStaticLayers addObject:canvas];
    return canvas;
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

GGLazyGetMethod(NSMutableArray, visibleLayers);
GGLazyGetMethod(NSMutableArray, idleLayers);

GGLazyGetMethod(NSMutableArray, visibleStaticLayers);
GGLazyGetMethod(NSMutableArray, idleStaticLayers);

@end
