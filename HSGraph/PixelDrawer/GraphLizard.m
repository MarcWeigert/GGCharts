//
//  GraphLizard.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "GraphLizard.h"
#import "LineBrush.h"
#import "TextBrush.h"

@interface GraphLizard ()

@property (nonatomic) NSMutableArray * blockAry;

@property (nonatomic) LineBrush *line;

@property (nonatomic) TextBrush *text;

@property (nonatomic) CGRect frame;

@end

@implementation GraphLizard

/** 初始化 */
- (id)initWithFrame:(CGRect)frame
{
    self = [super init];
    
    if (self) {
        
        _blockAry = [NSMutableArray array];
        _frame = frame;
    }
    
    return self;
}

- (LineBrush *)makeLine
{
    if (_line == nil) {
        
        _line = [[LineBrush alloc] initWithArray:_blockAry drawFrame:_frame];
    }
    
    return _line;
}

- (TextBrush *)makeText
{
    if (_text == nil) {
    
        _text = [[TextBrush alloc] initWithArray:_blockAry drawFrame:_frame];
    }
    
    return _text;
}

- (NSArray *)blockAry
{
    return [NSArray arrayWithArray:_blockAry];
}

@end
