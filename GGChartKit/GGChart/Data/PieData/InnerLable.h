//
//  InnerLable.h
//  GGCharts
//
//  Created by _ | Durex on 17/9/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NumberData.h"

@interface InnerLable : NumberData <PieInnerLableAbstract>

/**
 * 扇形图富文本字符串
 */
@property (nonatomic, copy) NSAttributedString * (^attributeStringBlock)(NSInteger index, CGFloat value, CGFloat ratio);

@end
