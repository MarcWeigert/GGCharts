//
//  ToolDefine.h
//  111
//
//  Created by _ | Durex on 2017/5/21.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#ifndef ToolDefine_h
#define ToolDefine_h

#define GGPropStatementAndFuncStatement(propertyModifyWord,className, propertyPointerType, propertyName)                 \
@property(nonatomic,propertyModifyWord)propertyPointerType  propertyName;                                            \
- (className * (^) (propertyPointerType propertyName)) propertyName##Set;

#define GGPropSetFuncImplementation(className, propertyPointerType, propertyName)                                       \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{                                                \
return ^(propertyPointerType propertyName) {                                                                            \
self.propertyName = propertyName;                                                                                       \
return self;                                                                                                            \
};                                                                                                                      \
}

#define GGPointMake(x, y)   [NSValue valueWithCGPoint:CGPointMake((x), (y))]
#define GGPoint(point)      [NSValue valueWithCGPoint:point]

#define NumberAry           NSArray <NSNumber *>*

#endif /* ToolDefine_h */
