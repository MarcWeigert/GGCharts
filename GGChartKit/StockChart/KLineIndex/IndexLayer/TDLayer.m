//
//  TDLayer.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/17.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "TDLayer.h"
#import "GGGraphics.h"

@interface TDLayer ()

@property (nonatomic, strong) NSArray * aryTDs;
@property (nonatomic, strong) NSArray * kLineAry;

@property (nonatomic, strong) CAShapeLayer * redArrowLayer;
@property (nonatomic, strong) CAShapeLayer * greenArrowLayer;
@property (nonatomic, strong) CAShapeLayer * upDownLineLayer;

@property (nonatomic, strong) CAShapeLayer * upDashLineLayer;
@property (nonatomic, strong) CAShapeLayer * downDashLineLayer;

@property (nonatomic, strong) DLineScaler * lineScaler;

@property (nonatomic, assign) NSInteger dashLineCount;

@end

@implementation TDLayer

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    _redArrowLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _greenArrowLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _upDownLineLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _upDashLineLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    _downDashLineLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    
    self.lineScaler.rect = CGRectMake(0, 0, self.gg_width, self.gg_height);
}

/**
 * 获取区间最大值最小值
 */
- (void)getIndexWithRange:(NSRange)range max:(CGFloat *)max min:(CGFloat *)min
{
    CGFloat base = *max - *min;
    
    *max = *max + base * .1f;
    *min = *min - base * .1f;
}

- (NSAttributedString *)attrStringWithIndex:(NSInteger)index
{
    NSDictionary * dictionary = self.aryTDs[index];
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:@"TD(9)"];
    
    if ([dictionary[@"dir"] integerValue] > 0) {
    
        NSString * string = [NSString stringWithFormat:@"  TD上行计数 %zd",[dictionary[@"dir"] integerValue]];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : RGB(234, 82, 83)}]];
    }
    else if ([dictionary[@"dir"] integerValue] < 0) {
    
        NSString * string = [NSString stringWithFormat:@"  下行计数 %zd", labs([dictionary[@"dir"] integerValue])];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : RGB(77, 166, 73)}]];
    }
    
    if ([dictionary[@"arrow"] integerValue] > 0) {
        
        NSString * string = [NSString stringWithFormat:@"  交易机会"];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : RGB(115, 190, 222)}]];
    }
    else if ([dictionary[@"arrow"] integerValue] < 0) {
        
        NSString * string = [NSString stringWithFormat:@"  风险管控"];
        [attrString appendAttributedString:[[NSAttributedString alloc] initWithString:string attributes:@{NSForegroundColorAttributeName : RGB(115, 190, 222)}]];
    }
    
    return attrString;
}

- (void)setKLineArray:(NSArray <id<KLineAbstract>> *)kLineArray
{
    _kLineAry = kLineArray;
    
    NSArray * kDataJson = [NSArray JsonFromObj:kLineArray];
    
    [self.lineScaler setObjAry:_kLineAry getSelector:@selector(ggHigh)];
    
    _aryTDs = [[KLineIndexManager shareInstans] getTDIndexWith:kDataJson
                                                         param:@9
                                               highPriceString:@"high"
                                                lowPriceString:@"low"
                                              closePriceString:@"close"];
    
    
    [self registerSideForPositiveColor:RGB(234, 82, 83)
                         negativeColor:RGB(77, 166, 73)
                       upDownLineColor:RGB(115, 190, 222)];
    
    
    __block NSInteger lineCount = 0;
    
    [_aryTDs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj[@"dir"] integerValue] == 9 || [obj[@"dir"] integerValue] == -9) {
            
            lineCount++;
        }
    }];
    
    _dashLineCount = lineCount;
    
    self.lineScaler.rect = CGRectMake(0, 0, self.gg_width, self.gg_height);
}

- (void)registerSideForPositiveColor:(UIColor *)positiveColor
                       negativeColor:(UIColor *)negativeColor
                     upDownLineColor:(UIColor *)upDownLineColor
{
    [_redArrowLayer removeFromSuperlayer];
    [_greenArrowLayer removeFromSuperlayer];
    [_upDownLineLayer removeFromSuperlayer];
    [_upDashLineLayer removeFromSuperlayer];
    
    _upDownLineLayer = [CAShapeLayer layer];
    _upDownLineLayer.fillColor = [UIColor clearColor].CGColor;
    _upDownLineLayer.strokeColor = upDownLineColor.CGColor;
    _upDownLineLayer.lineWidth = 1;
    _upDownLineLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_upDownLineLayer];
    
    _greenArrowLayer = [CAShapeLayer layer];
    _greenArrowLayer.fillColor = negativeColor.CGColor;
    _greenArrowLayer.strokeColor = negativeColor.CGColor;
    _greenArrowLayer.lineWidth = 0;
    _greenArrowLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_greenArrowLayer];
    
    _redArrowLayer = [CAShapeLayer layer];
    _redArrowLayer.fillColor = positiveColor.CGColor;
    _redArrowLayer.strokeColor = positiveColor.CGColor;
    _redArrowLayer.lineWidth = 0;
    _redArrowLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_redArrowLayer];
    
    _upDashLineLayer = [CAShapeLayer layer];
    _upDashLineLayer.fillColor = positiveColor.CGColor;
    _upDashLineLayer.strokeColor = positiveColor.CGColor;
    _upDashLineLayer.lineWidth = 1;
    _upDashLineLayer.lineDashPattern = @[@2, @2];
    _upDashLineLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_upDashLineLayer];
    
    _downDashLineLayer = [CAShapeLayer layer];
    _downDashLineLayer.fillColor = negativeColor.CGColor;
    _downDashLineLayer.strokeColor = negativeColor.CGColor;
    _downDashLineLayer.lineWidth = 1;
    _downDashLineLayer.lineDashPattern = @[@2, @2];
    _downDashLineLayer.frame = CGRectMake(0, 0, self.gg_width, self.gg_height);
    [self addSublayer:_downDashLineLayer];
}

/**
 * 绘制层数据
 */
- (void)updateLayerWithRange:(NSRange)range max:(CGFloat)max min:(CGFloat)min
{
    CGMutablePathRef redRef = CGPathCreateMutable();
    CGMutablePathRef greenRef = CGPathCreateMutable();
    CGMutablePathRef upDownRef = CGPathCreateMutable();
    
    CGMutablePathRef dashRefRed = CGPathCreateMutable();
    CGMutablePathRef dashRefGreen = CGPathCreateMutable();
    
    // 更新k线层
    self.lineScaler.max = max;
    self.lineScaler.min = min;
    [self.lineScaler updateScaler];
    
    [self removeAllRenderer];
    
    GGLine * lines = malloc(sizeof(GGLine) * _dashLineCount);
    NSInteger lineSize = 0;
    
    for (NSInteger i = 0; i < _aryTDs.count ; i++) {
        
        NSDictionary * dic = _aryTDs[i];
        NSInteger arrow = [dic[@"arrow"] integerValue];
        
        if (arrow == -1) {
            
            CGPoint point = self.lineScaler.linePoints[i];
            point.y = [self.lineScaler getYPixelWithData:[_kLineAry[i] ggHigh]];
            
            CGPoint lineStart = point;
            lineStart.y -= self.currentKLineWidth;
            CGPoint lineEnd = point;
            lineEnd.y -= (self.currentKLineWidth - 3);
            
            if ([dic[@"dir"] integerValue] != 0) {
                
                lineStart.y -= 10;
                lineEnd.y -= 10;
            }
            
            GGArrow arrow = GGArrowLineMake(GGPointLineMake(lineStart, lineEnd), self.currentKLineWidth * 1.5);
            GGPathAddArrow(greenRef, arrow, self.currentKLineWidth / 2);
        }
        else if (arrow == 1) {
        
            CGPoint point = self.lineScaler.linePoints[i];
            point.y = [self.lineScaler getYPixelWithData:[_kLineAry[i] ggLow]];
            
            CGPoint lineStart = point;
            lineStart.y += self.currentKLineWidth;
            CGPoint lineEnd = point;
            lineEnd.y += (self.currentKLineWidth - 3);
            
            if ([dic[@"dir"] integerValue] != 0) {
                
                lineStart.y += 10;
                lineEnd.y += 10;
            }
            
            GGArrow arrow = GGArrowLineMake(GGPointLineMake(lineStart, lineEnd), self.currentKLineWidth * 1.5);
            GGPathAddArrow(redRef, arrow, self.currentKLineWidth / 2);
        }
        
        // 文字
        NSInteger dir = [dic[@"dir"] integerValue];
        
        if (dir == 9 || dir == -9) {
            
            CGPoint point = self.lineScaler.linePoints[i];
            point.y = [self.lineScaler getYPixelWithData:dir > 0 ? [_kLineAry[i] ggHigh] : [_kLineAry[i] ggLow]];
            
            lines[lineSize] = GGPointLineMake(point, point);
            
            NSInteger before = lineSize - 1;
            
            if (before >= 0) {
                
                lines[before].end.x = point.x;
            }
            
            lines[lineSize].start.x = dir > 0 ? point.x : -point.x;
            
            lineSize++;
        }
        
        if (dir != 0) {
            
            GGStringRenderer *renderer = [[GGStringRenderer alloc] init];
            renderer.string = @(labs(dir)).stringValue;
            
            if (dir > 0) {
                
                CGPoint point = self.lineScaler.linePoints[i];
                point.y = [self.lineScaler getYPixelWithData:[_kLineAry[i] ggHigh]] - 6;
                
                GGCircle circle = GGCirclePointMake(point, self.currentKLineWidth / 3);
                GGPathAddCircle(redRef, circle);
                
                if (dir == 1) {
                    
                    CGPathMoveToPoint(upDownRef, NULL, point.x, point.y);
                }
                else {
                
                    CGPathAddLineToPoint(upDownRef, NULL, point.x, point.y);
                }
            }
            else {
                
                CGPoint point = self.lineScaler.linePoints[i];
                point.y = [self.lineScaler getYPixelWithData:[_kLineAry[i] ggLow]] + 6;

                GGCircle circle = GGCirclePointMake(point, self.currentKLineWidth / 3);
                GGPathAddCircle(greenRef, circle);
                
                if (dir == -1) {
                    
                    CGPathMoveToPoint(upDownRef, NULL, point.x, point.y);
                }
                else {
                    
                    CGPathAddLineToPoint(upDownRef, NULL, point.x, point.y);
                }
            }
        }
    }
    
    for (NSInteger i = 0; i < lineSize; i++) {
        
        if (lines[i].start.x < 0) {
            
            lines[i].start.x *= -1;
            
            GGPathAddLine(dashRefGreen, lines[i]);
        }
        else{
            
            GGPathAddLine(dashRefRed, lines[i]);
        }
    }
    
    _upDashLineLayer.path = dashRefRed;
    _downDashLineLayer.path = dashRefGreen;
    _redArrowLayer.path = redRef;
    _greenArrowLayer.path = greenRef;
    _upDownLineLayer.path = upDownRef;

    CGPathRelease(upDownRef);
    CGPathRelease(greenRef);
    CGPathRelease(redRef);
    CGPathRelease(dashRefRed);
    CGPathRelease(dashRefGreen);
    
    free(lines);
}

#pragma mark - GGLazy

GGLazyGetMethod(DLineScaler, lineScaler);

@end
