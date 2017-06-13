//
//  PieChart.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "PieChart.h"
#import "GGChartGeometry.h"
#import "CGPathCategory.h"
#import "GGCircleRenderer.h"
#import "UICountingLabel.h"

#define PIE_ANIMATION_FRAME     1000
#define BACK_LAYER_TAG          2000
#define BACK_CENTER_TAG         3000

@interface PieChart ()

@property (nonatomic, strong) GGCircleRenderer * renderer;

@property (nonatomic) NSMutableArray * aryCountLabels;

@end

@implementation PieChart

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _renderer = [[GGCircleRenderer alloc] init];
        _renderer.borderWidth = 0.7;
        _renderer.borderColor = [[UIColor grayColor] colorWithAlphaComponent:0.5];
        
        [ChartBack(BACK_LAYER_TAG) addRenderer:_renderer];
        
        _aryCountLabels = [NSMutableArray array];
    }
    
    return self;
}

- (UICountingLabel *)getLable:(NSInteger)index
{
    if (_aryCountLabels.count <= index) {
        
        UICountingLabel * countLable = [[UICountingLabel alloc] initWithFrame:CGRectZero];
        countLable.font = [UIFont systemFontOfSize:12];
        countLable.method = UILabelCountingMethodLinear;
        countLable.format = @"%.2f";
        countLable.textAlignment = NSTextAlignmentCenter;
        [self addSubview:countLable];
        [_aryCountLabels addObject:countLable];
    }
    
    return _aryCountLabels[index];
}

- (void)strockChart
{
    [_aryCountLabels enumerateObjectsUsingBlock:^(UICountingLabel * obj, NSUInteger idx, BOOL * stop) {
        
        [obj removeFromSuperview];
    }];
    
    [PieChartData pieAry:_sectorAry enumerateObjectsUsingBlock:^(CGFloat arc, CGFloat transArc, PieChartData *data, NSUInteger idx) {
        
        data.ratio = arc / (M_PI * 2);
        
        // pie 图表
        GGShapeCanvas * shape = ChartPie(idx);
        shape.fillColor = data.color.CGColor;
        shape.strokeColor = data.color.CGColor;
        shape.lineWidth = 0;
        
        CGMutablePathRef ref = CGPathCreateMutable();
        CGPoint center = CGPointMake(shape.frame.size.width / 2, shape.frame.size.width / 2);
        GGSector sector = GGSectorCenterMake(center, 0, arc, _radius);
        GGPathAddSector(ref, sector);
        shape.path = ref;
        CGPathRelease(ref);
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        shape.affineTransform = CGAffineTransformRotate(transform, transArc);
        
        [shape registerKeyAnimation:@"path"
                               name:@"pie_move"
                             values:GGPathAnimationArrayFor(sector, PIE_ANIMATION_FRAME)];
        
        [shape registerKeyAnimation:@"transform.scale"
                               name:@"pie_scale"
                             values:@[@0, @1]];
        
        [shape registerKeyAnimation:@"transform.rotation"
                               name:@"pie_rotation"
                             values:@[@(-M_PI_2), @(transArc)]];
        
        [self.layer addSublayer:shape];
        
        // pie 分割线
        GGShapeCanvas * shapeSpa = ChartShape(idx + 1000);
        shapeSpa.lineWidth = 1;
        shapeSpa.fillColor = data.color.CGColor;
        shapeSpa.strokeColor = data.color.CGColor;
        
        CGMutablePathRef refs = CGPathCreateMutable();
        CGPoint draw_center = CGPointMake(shapeSpa.frame.size.width / 2, shapeSpa.frame.size.height / 2);
        GGArcLine arcLine = GGArcLineMake(draw_center, transArc + arc / 2, _radius + 30);
        GGLine line = GGLineWithArcLine(arcLine, false);
        GGLine line_m = GGLineMoveStart(line, _radius + 10);
        CGPoint end_pt = GGGetLineEndPointArcMoveX(line_m, 10);
        GGCircle circle = GGCirclePointMake(end_pt, 2);
        GGPathAddCircle(refs, circle);
        GGPathAddLine(refs, line_m);
        CGPathMoveToPoint(refs, NULL, line_m.end.x, line_m.end.y);
        CGPathAddLineToPoint(refs, NULL, end_pt.x, end_pt.y);

        shapeSpa.path = refs;
        CGPathRelease(refs);
        
        CGMutablePathRef ref1 = CGPathCreateMutable();
        CGMutablePathRef ref2 = CGPathCreateMutable();
        CGMutablePathRef ref3 = CGPathCreateMutable();
        CGMutablePathRef ref4 = CGPathCreateMutable();
        CGMutablePathRef ref5 = CGPathCreateMutable();
        CGMutablePathRef ref6 = CGPathCreateMutable();
        
        CGPathMoveToPoint(ref1, NULL, line_m.start.x, line_m.start.y);
        
        GGPathAddLine(ref2, line_m);
        
        GGPathAddLine(ref3, line_m);
        CGPathMoveToPoint(ref3, NULL, line_m.end.x, line_m.end.y);
        CGPathAddLineToPoint(ref3, NULL, end_pt.x, end_pt.y);
        
        GGPathAddLine(ref4, line_m);
        CGPathMoveToPoint(ref4, NULL, line_m.end.x, line_m.end.y);
        CGPathAddLineToPoint(ref4, NULL, end_pt.x, end_pt.y);
        GGPathAddCircle(ref4, circle);
        
        GGPathAddLine(ref5, line_m);
        CGPathMoveToPoint(ref5, NULL, line_m.end.x, line_m.end.y);
        CGPathAddLineToPoint(ref5, NULL, end_pt.x, end_pt.y);
        GGPathAddCircle(ref5, GGCirclePointMake(end_pt, 2.5));
        
        GGPathAddLine(ref6, line_m);
        CGPathMoveToPoint(ref6, NULL, line_m.end.x, line_m.end.y);
        CGPathAddLineToPoint(ref6, NULL, end_pt.x, end_pt.y);
        GGPathAddCircle(ref6, circle);
        
        [shapeSpa registerKeyAnimation:@"path"
                                  name:@"spa_ani"
                                values:@[(__bridge id)ref1,
                                         (__bridge id)ref2,
                                         (__bridge id)ref3,
                                         (__bridge id)ref4,
                                         (__bridge id)ref5,
                                         (__bridge id)ref6]];
        
        CGFloat line_arc = GGYCircular(line);
        UICountingLabel * lbCount = [self getLable:idx];
        lbCount.formatBlock = ^(CGFloat value) {
            
            return [NSString stringWithFormat:@"%d%%", (int)(value * 100)];
        };
        
        CGSize size = [@"100%" sizeWithAttributes:@{NSFontAttributeName : lbCount.font}];
        CGPoint orgz = line_arc > 0 ? CGPointMake(end_pt.x + 4, end_pt.y - size.height / 2) : CGPointMake(end_pt.x - 4 - size.width, end_pt.y - size.height / 2);
        lbCount.frame = CGRectMake(orgz.x, orgz.y, size.width, size.height);
        [self addSubview:lbCount];
    }];
    
    _renderer.circle = GGCirclePointMake(CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2), _radius + 5);
    [ChartBack(BACK_LAYER_TAG) setNeedsDisplay];
    
    GGCircleRenderer * renderer = [GGCircleRenderer new];
    renderer.fillColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    renderer.circle = GGCirclePointMake(CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2), _radius / 2);
    [ChartBack(BACK_CENTER_TAG) addRenderer:renderer];
    [ChartBack(BACK_CENTER_TAG) setNeedsDisplay];
}

- (void)addAnimationWithDuration:(NSTimeInterval)duration
{
    for (NSInteger i = 0; i < _sectorAry.count; i++) {
        
        GGShapeCanvas * shape = ChartPie(i);
        
        [shape startAnimation:@"pie_move" duration:duration];
        [shape startAnimation:@"pie_scale" duration:duration];
        [shape startAnimation:@"pie_rotation" duration:duration];
        [ChartShape(i + 1000) startAnimation:@"spa_ani" duration:duration];
    }
    
    [_sectorAry enumerateObjectsUsingBlock:^(PieChartData * obj, NSUInteger idx, BOOL * stop) {
        
        UICountingLabel * lbCount = [self getLable:idx];
        
        [lbCount countFrom:0 to:obj.ratio withDuration:duration];
    }];
}

@end
