//
//  TDLayer.m
//  GGCharts
//
//  Created by 黄舜 on 17/7/17.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "TDLayer.h"
#import "GGGraphics.h"

@interface TDLayer ()

@property (nonatomic, strong) NSArray * aryTDs;

@property (nonatomic, strong) CAShapeLayer * positiveLayer;
@property (nonatomic, strong) CAShapeLayer * negativeLayer;

@end

@implementation TDLayer

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _positiveLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _negativeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (NSAttributedString *)attrStringWithIndex:(NSInteger)index
{
    return [[NSAttributedString alloc] initWithString:@"TD(9)"];
}

- (void)setKLineArray:(NSArray <id<KLineAbstract>> *)kLineArray
{
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    self.datas = kDataJson;
    
    _aryTDs = [[KLineIndexManager shareInstans] getTDIndexWith:kDataJson
                                                         param:@9
                                               highPriceString:@"high"
                                                lowPriceString:@"low"
                                              closePriceString:@"close"];
    
    
    [self registerSideForPositiveColor:RGB(234, 82, 83)
                         negativeColor:RGB(77, 166, 73)];
}

- (void)registerSideForPositiveColor:(UIColor *)positiveColor
                       negativeColor:(UIColor *)negativeColor
{
    [_positiveLayer removeFromSuperlayer];
    [_negativeLayer removeFromSuperlayer];
        
    _negativeLayer = [CAShapeLayer layer];
    _negativeLayer.fillColor = negativeColor.CGColor;
    _negativeLayer.strokeColor = negativeColor.CGColor;
    _negativeLayer.lineWidth = 0;
    _negativeLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_negativeLayer];
    
    _positiveLayer = [CAShapeLayer layer];
    _positiveLayer.fillColor = positiveColor.CGColor;
    _positiveLayer.strokeColor = positiveColor.CGColor;
    _positiveLayer.lineWidth = 0;
    _positiveLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_positiveLayer];
}

/**
 * 绘制层数据
 */
- (void)updateLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min
{
    NSUInteger count = NSMaxRange(range);
    
    CGMutablePathRef refRed = CGPathCreateMutable();
    CGMutablePathRef refGreen = CGPathCreateMutable();
    
    [self removeAllRenderer];
    
    for (NSInteger i = range.location; i < count; i++) {
        
        NSDictionary * dic = _aryTDs[i];
        NSInteger arrow = [dic[@"arrow"] integerValue];
        GGKShape shape = self.kScaler.kShapes[i];
        
        if (arrow == -1) {
            
            GGSide side = GGSideMake(CGPointMake(shape.end.x, shape.end.y + 10), 10, 3);
            GGPathAddGGSide(refGreen, side, 0);
        }
        else if (arrow == 1) {
        
            GGSide side = GGSideMake(CGPointMake(shape.top.x, shape.top.y - 10), 10, 3);
            GGPathAddGGSide(refRed, side, M_PI);
        }
        
        NSInteger dir = [dic[@"dir"] integerValue];
        
        if (dir != 0) {
            
            GGStringRenderer *renderer = [[GGStringRenderer alloc] init];
            renderer.string = @(labs(dir)).stringValue;
            [self addRenderer:renderer];
            
            if (dir > 0) {
                
                renderer.point = shape.top;
                renderer.offSetRatio = CGPointMake(-.5, -1);
                
                //renderer.color = [UIColor yellowColor];
            }
            else {
            
                renderer.point = shape.end;
                renderer.offSetRatio = CGPointMake(-.5, 0);
                //renderer.color = [UIColor yellowColor];
            }
        }
    }
    
    [self setNeedsDisplay];
    
    //_positiveLayer.path = refRed;
    //_negativeLayer.path = refGreen;
}

@end
