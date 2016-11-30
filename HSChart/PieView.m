//
//  PieView.m
//  HSCharts
//
//  Created by 黄舜 on 16/11/29.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "PieView.h"
#import "SawGraph.h"
#import "Colors.h"
#import "QueryView.h"

@interface PieView ()

@property (nonatomic) CALayer *contentLayer;

@property (nonatomic) CGFloat radius;

@property (nonatomic) VirginLayer *backLayer;

@property (nonatomic) QueryView *qyView;

@property (nonatomic) NSArray<NSArray<NSNumber *> *> *angleArys;

@property (nonatomic) NSArray *cornerPointAry;   ///< 拐弯点数组

@property (nonatomic) NSArray *endPointAry;   ///< 结束点数组

@end

@implementation PieView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _contentLayer = [[CALayer alloc] init];
        _backLayer = [[VirginLayer alloc] init];
        
        [self setFrame:frame];
        [self.layer addSublayer:_backLayer];
        [_backLayer addSublayer:_contentLayer];
        
        _qyView = [[QueryView alloc] initWithFrame:CGRectZero];
        _qyView.font = [UIFont systemFontOfSize:12];
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _backLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _contentLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _radius = self.frame.size.width > self.frame.size.height ? self.frame.size.width / 2.5 : self.frame.size.height / 2.5 - 25;
}

- (void)makeContentLayer
{
    _angleArys = [_contentLayer draw_makeSpiders:^(GraphSpider *make) {
        
        [_colorAry enumerateObjectsUsingBlock:^(UIColor *color, NSUInteger i, BOOL * stop) {
            
            make.drawRound.drawAry(_dataAry, i).radius(_radius).fillColor(color);
        }];
    }];
}

- (void)makeBackLayer
{
    [_backLayer draw_updateFrame:CGRectMake(0, 0, _backLayer.width, _backLayer.height) lizard:^(GraphLizard *make) {
        
        UIColor *color = [UIColor blackColor];
        
        [_cornerPointAry enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
            
            UIFont *font = [UIFont systemFontOfSize:_backLayer.frame.size.width / self.bounds.size.width * 9];
            CGPoint from = [(NSValue *)obj CGPointValue];
            CGPoint to = [(NSValue *)_endPointAry[idx] CGPointValue];
            CGPoint center = CGPointMake(_backLayer.width / 2, _backLayer.height / 2);
            
            make.makeLine.color(__RGB_BLACK).width(0.6);
            make.makeLine.line(from, to);
            make.makeLine.draw();
            make.makeLine.line(center, from);
            make.makeLine.draw();
            
            NSString *text = _titleAry[idx];
            make.makeText.text(text).font(font).color(color);

            if (to.x > _backLayer.width / 2) {
                
                make.makeText.point(to).type(T_RIGHT);
                make.makeText.draw();
            }
            else {

                make.makeText.point(to).type(T_LEFT);
                make.makeText.draw();
            }
        }];
    }];
}

/** 生成折线拐点与终点 */
- (void)loadPointArys:(CGFloat)radius
{
    NSMutableArray *cornerAry = [NSMutableArray array];
    NSMutableArray *endAry = [NSMutableArray array];
    
    CGFloat width = _radius / 15;
    CGPoint cornerPt = CGPointZero;
    CGPoint endPt = CGPointZero;
    CGPoint centerPt = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    
    for (NSArray *ary in _angleArys) {
        
        CGFloat start = [ary.firstObject floatValue];
        CGFloat end = [ary.lastObject floatValue];
        
        CGFloat corner = end - start;
        CGFloat center = start + corner / 2;
        
        cornerPt = angleWithZero(centerPt, center, radius, NO);
        
        if (isWest(center)) {
            
            endPt = CGPointMake(cornerPt.x - width, cornerPt.y);
        }
        else {
            
            endPt = CGPointMake(cornerPt.x + width, cornerPt.y);
        }
        
        [endAry addObject:[NSValue valueWithCGPoint:endPt]];
        [cornerAry addObject:[NSValue valueWithCGPoint:cornerPt]];
    }
    
    _cornerPointAry = [NSArray arrayWithArray:cornerAry];
    _endPointAry = [NSArray arrayWithArray:endAry];
}

- (void)stockChart
{
    [self makeContentLayer];
    [self loadPointArys:_radius * 1.125];
    [self makeBackLayer];
}

@end
