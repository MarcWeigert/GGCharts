//
//  PieInnerLableAbstract.h
//  GGCharts
//
//  Created by 黄舜 on 17/9/19.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef PieInnerLableAbstract_h
#define PieInnerLableAbstract_h

#import "NumberAbstract.h"

@protocol PieInnerLableAbstract <NumberAbstract>

/**
 * 扇形图富文本字符串
 */
@property (nonatomic, copy, readonly) NSAttributedString * (^attributeStringBlock)(NSInteger index, CGFloat ratio);

@end


#endif /* PieInnerLableAbstract_h */
