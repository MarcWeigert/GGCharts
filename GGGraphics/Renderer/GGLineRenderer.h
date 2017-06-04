//
//  GGLine.h
//  111
//
//  Created by _ | Durex on 2017/5/14.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGRenderProtocol.h"
#import "ToolDefine.h"

@interface GGLineRenderer : NSObject <GGRenderProtocol>

AAPropStatementAndFuncStatement(assign, GGLineRenderer, CGFloat, width);

AAPropStatementAndFuncStatement(assign, GGLineRenderer, UIColor *, color);

AAPropStatementAndFuncStatement(strong, GGLineRenderer, NSArray <NSValue *>*, pointAry);

@end
