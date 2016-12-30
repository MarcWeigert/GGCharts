//
//  GGLayer.m
//  HSCharts
//
//  Created by 黄舜 on 16/12/29.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "GGLayer.h"
#import <UIKit/UIKit.h>

@interface GGLayer ()

@property (nonatomic, strong) NSMutableArray <id<GGLayerProtocal>> *brushAry;

@end

@implementation GGLayer

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        _brushAry = [NSMutableArray array];
        self.masksToBounds = YES;   // 剪裁是否可以超出范围
        self.contentsScale = [[UIScreen mainScreen] scale];   // 绘制的最低像素点
    }
    
    return self;
}

- (void)addBrush:(id <GGLayerProtocal>)brush
{
    [_brushAry addObject:brush];
}

- (void)drawInContext:(CGContextRef)ctx
{    
    for (id <GGLayerProtocal> brush in _brushAry) {
        
        brush.drawForContextRef(ctx);
    }
}

@end
