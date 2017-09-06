//
//  LineQueryData.m
//  GGCharts
//
//  Created by 黄舜 on 17/9/4.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineQueryData.h"

@implementation LineQueryData

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _queryLineColor = [UIColor blackColor];
        _queryLineWidth = .5f;
        
        _queryTextInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        _queryTextBackColor = [UIColor blackColor];
        _queryTextFont = [UIFont systemFontOfSize:12];
    }
    
    return self;
}

@end
