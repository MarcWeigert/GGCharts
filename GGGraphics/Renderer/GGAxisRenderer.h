//
//  GGAxisRenderer.h
//  111
//
//  Created by _ | Durex on 2017/5/27.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGChart.h"

@interface GGAxisRenderer : NSObject <GGRenderProtocol>

AAPropStatementAndFuncStatement(assign, GGAxisRenderer, GGAxis, axis);

AAPropStatementAndFuncStatement(assign, GGAxisRenderer, CGFloat, width);

AAPropStatementAndFuncStatement(strong, GGAxisRenderer, UIColor *, color);

@end
