//
//  OutSideLable.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "OutSideLable.h"

@implementation OutSideLable

/**
 * 初始化方法
 */
- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _lineWidth = 1;
        _lineSpacing = 0;
        _lineLength = 15;
        _inflectionLength = 10;
        _linePointRadius = 1.5;
        self.stringRatio = GGRatioCenterRight;
        self.stringOffSet = CGSizeMake(4, 0);
    }
    
    return self;
}

@end
