//
//  GraphLizard.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/14.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class LineBrush;
@class TextBrush;

@interface GraphLizard : NSObject

@property (nonatomic, readonly) LineBrush *makeLine;

@property (nonatomic, readonly) TextBrush *makeText;

@property (nonatomic, readonly) NSArray *blockAry;

/** 初始化 */
- (id)initWithFrame:(CGRect)frame;

@end
