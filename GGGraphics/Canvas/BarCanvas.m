//
//  BarCanvas.m
//  GGCharts
//
//  Created by _ | Durex on 2017/8/13.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "BarCanvas.h"
#import "GGRectRenderer.h"

@interface BarCanvas ()

/**
 * 文字数据
 */
@property (nonatomic, strong) NSMutableArray <GGNumberRenderer *> * allGGNumberArray;

@end

@implementation BarCanvas

/**
 * 绘制图表(父类方法)
 */
- (void)drawChart
{
    [super drawChart];
    
    // 清空文字信息
    [self.allGGNumberArray removeAllObjects];
    
    for (NSInteger i = 0; i < [_barDrawConfig barAry].count; i++) {
        
        [self drawBarRectsWidthBar:[_barDrawConfig barAry][i] section:i];
        [self drawBarStringWithBar:[_barDrawConfig barAry][i]];
    }
}

/**
 * 绘制柱状图
 */
- (void)drawBarRectsWidthBar:(id <BarDrawAbstract>)barAbstract section:(NSInteger)section
{
    GGShapeCanvas * shapeCanvas = [self getGGShapeCanvasEqualFrame];
    shapeCanvas.fillColor = [barAbstract barFillColor].CGColor;
    shapeCanvas.lineWidth = [barAbstract borderWidth];
    shapeCanvas.strokeColor = [barAbstract barBorderColor].CGColor;
    
    CGMutablePathRef ref = CGPathCreateMutable();
    GGpathAddCGRects(ref, [barAbstract barRects], [barAbstract dataAry].count);
    shapeCanvas.path = ref;
    CGPathRelease(ref);
    
    if ([_barDrawConfig barColorsAtIndexPath]) {    // 分布绘制颜色
        
        GGCanvas * canvas = [self getCanvasEqualFrame];
        canvas.isCashBeforeRenderers = YES;
        [canvas removeAllRenderer];
        [shapeCanvas removeFromSuperlayer];
        
        for (NSInteger row = 0; row < [barAbstract dataAry].count; row++) {
            
            NSNumber * data = [barAbstract dataAry][row];
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            UIColor * blockColor = [_barDrawConfig barColorsAtIndexPath](indexPath, data);
            
            GGRectRenderer * rectRenderder = [[GGRectRenderer alloc] init];
            rectRenderder.rect = [barAbstract barRects][row];
            rectRenderder.fillColor = blockColor == nil ? [barAbstract barFillColor] : blockColor;
            [canvas addRenderer:rectRenderder];
        
            canvas.mask = shapeCanvas;
        }
        
        [canvas setNeedsDisplay];
        
        [shapeCanvas pathChangeAnimation:3];
    }
}

/**
 * 绘制文字
 */
- (void)drawBarStringWithBar:(id <BarDrawAbstract>)barAbstract
{
    if ([barAbstract stringFont] != nil &&
        [barAbstract stringColor] != nil) {
        
        GGCanvas * stringCanvas = [self getCanvasEqualFrame];
        [stringCanvas removeAllRenderer];
        
        for (NSInteger i = 0; i < [barAbstract dataAry].count; i++) {
            
            CGRect rect = [barAbstract barRects][i];
            CGFloat x = rect.origin.x - [barAbstract offSetRatio].x * rect.size.width;
            CGFloat y = rect.origin.y + ([barAbstract offSetRatio].y + 1) * rect.size.height;
            
            GGNumberRenderer * number = [[GGNumberRenderer alloc] init];
            number.offSetRatio = [barAbstract offSetRatio];
            number.format = [barAbstract dataFormatter];
            number.fromNumber = 0;
            number.toNumber = [[barAbstract dataAry][i] floatValue];
            number.fromPoint = CGPointZero;
            number.toPoint = CGPointMake(x, y);
            number.offSet = [barAbstract stringOffset];
            
            [number drawAtToNumberAndPoint];
            [stringCanvas addRenderer:number];
        }
        
        [stringCanvas setNeedsDisplay];
    }
}


#pragma mark - Lazy

GGLazyGetMethod(NSMutableArray, allGGNumberArray);

@end
