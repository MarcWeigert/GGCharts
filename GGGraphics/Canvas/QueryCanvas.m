//
//  QueryCanvas.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "QueryCanvas.h"

@interface QueryCanvas ()

@property (nonatomic, strong) GGStringRenderer * xTopAxisLable;
@property (nonatomic, strong) GGStringRenderer * yLeftAxisLable;
@property (nonatomic, strong) GGStringRenderer * xBottomAxisLable;
@property (nonatomic, strong) GGStringRenderer * yRightAxisLable;

@property (nonatomic, strong) GGLineRenderer * xLine;
@property (nonatomic, strong) GGLineRenderer * yLine;

@end

@implementation QueryCanvas

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _xTopAxisLable = [[GGStringRenderer alloc] init];
        _xTopAxisLable.offSetRatio = CGPointMake(-.5f, 0);
        _xTopAxisLable.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        [self addRenderer:_xTopAxisLable];
        
        _yLeftAxisLable = [[GGStringRenderer alloc] init];
        _yLeftAxisLable.offSetRatio = CGPointMake(-.5f, 0);
        _yLeftAxisLable.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        [self addRenderer:_yLeftAxisLable];
        
        _xBottomAxisLable = [[GGStringRenderer alloc] init];
        _xBottomAxisLable.offSetRatio = CGPointMake(-.5f, 0);
        _xBottomAxisLable.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        [self addRenderer:_xBottomAxisLable];
        
        _yRightAxisLable = [[GGStringRenderer alloc] init];
        _yRightAxisLable.offSetRatio = CGPointMake(-.5f, 0);
        _yRightAxisLable.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        [self addRenderer:_yRightAxisLable];
        
        _xLine = [[GGLineRenderer alloc] init];
        [self addRenderer:_xLine];
        
        _yLine = [[GGLineRenderer alloc] init];
        [self addRenderer:_yLine];
    }
    
    return self;
}

- (void)setQueryDrawConfig:(id<QueryAbstract>)queryDrawConfig
{
    _queryDrawConfig = queryDrawConfig;
}

/**
 * 更新查价层
 *
 * touchPoint 显示中心点
 */
- (void)updateWithPoint:(CGPoint)touchPoint
{
    CGRect drawFrame = UIEdgeInsetsInsetRect(self.frame, [_queryDrawConfig insets]);
    
    _xLine.line = GGLineRectForX(drawFrame, touchPoint.x);
    _yLine.line = GGLineRectForY(drawFrame, touchPoint.y);
    
    [self setNeedsDisplay];
}

@end
