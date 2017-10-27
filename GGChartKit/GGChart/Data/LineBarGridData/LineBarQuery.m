//
//  LineBarQuery.m
//  GGCharts
//
//  Created by _ | Durex on 17/9/7.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "LineBarQuery.h"

@interface LineBarQuery () <QueryAbstract>

@end

@implementation LineBarQuery

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        _lableInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        _lineWidth = .5f;
        _lableFont = [UIFont systemFontOfSize:8];
        _lableColor = [UIColor blackColor];
        _lableBackgroundColor = [UIColor grayColor];
        _lableRadius = 2.0f;
    }
    
    return self;
}

@end
