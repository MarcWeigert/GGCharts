//
//  GGGride.h
//  111
//
//  Created by _ | Durex on 2017/5/22.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGChart.h"

@interface GGGridRenderer : NSObject <GGRenderProtocol>

AAPropStatementAndFuncStatement(assign, GGGridRenderer, CGFloat, width);

AAPropStatementAndFuncStatement(assign, GGGridRenderer, UIColor *, color);

AAPropStatementAndFuncStatement(assign, GGGridRenderer, GGGrid, grid);

@property (nonatomic, strong) NSNumber * x_count;

@property (nonatomic, strong) NSNumber * y_count;

@end
