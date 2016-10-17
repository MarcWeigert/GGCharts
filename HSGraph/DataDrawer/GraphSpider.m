//
//  GraphSpider.m
//  HCharts
//
//  Created by 黄舜 on 16/6/16.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "GraphSpider.h"
#import "LineShape.h"
#import "BarShape.h"
#import "RoundShape.h"

@interface GraphSpider ()

@property (nonatomic) NSArray *drawAry;

@property (nonatomic, weak) CALayer *layer;

@end

@implementation GraphSpider

- (id)initWithLayer:(CALayer *)layer
{
    self = [super init];
    
    if (self) {
        
        _layer = layer;
    }
    
    return self;
}

- (NSArray *)drawAry
{
    if (!_drawAry) {
        
        _drawAry = [NSArray array];
    }
    
    return _drawAry;
}

- (void)removeSubLayers
{
    NSArray *subLayers = [NSArray arrayWithArray:_layer.sublayers];
    
    for (CALayer *layer in subLayers) {
        
        [layer removeFromSuperlayer];
    }
}

- (NSArray *)stockShapeLayer
{
    NSMutableArray *pointArys = [NSMutableArray array];
    
    if (_removeLayers) {

        [self removeSubLayers];
    }
    
    for (NSInteger i = 0; i < _drawAry.count; i++) {
        
        id graph = _drawAry[i];
        
        CAShapeLayer *shapeLayer;
        
        if (_updateLayers && i < _layer.sublayers.count) {

            shapeLayer = (CAShapeLayer *)_layer.sublayers[i];
        }
        else {
        
            shapeLayer = [[CAShapeLayer alloc] init];
            [_layer addSublayer:shapeLayer];
        }
        
        [pointArys addObject:[graph stockLayer:shapeLayer]];
    }
    
    return [NSArray arrayWithArray:pointArys];
}

#pragma mark - Line

- (LineShape *)addLineShape
{
    LineShape *lineShape = [[LineShape alloc] initWithLayer:_layer];
    
    self.drawAry = [self.drawAry arrayByAddingObject:lineShape];
    
    return lineShape;
}

- (LineShape *)drawLine
{
    return [self addLineShape];
}

#pragma mark - Bar

- (BarShape *)addBarShape
{
    BarShape *barShape = [[BarShape alloc] initWithLayer:_layer];
    
    self.drawAry = [self.drawAry arrayByAddingObject:barShape];
    
    return barShape;
}

- (BarShape *)drawBar
{
    return [self addBarShape];
}

#pragma mark - Round

- (RoundShape *)addRoundShape
{
    RoundShape *barShape = [[RoundShape alloc] initWithLayer:_layer];
    
    self.drawAry = [self.drawAry arrayByAddingObject:barShape];
    
    return barShape;
}

- (RoundShape *)drawRound
{
    return [self addRoundShape];
}

@end
