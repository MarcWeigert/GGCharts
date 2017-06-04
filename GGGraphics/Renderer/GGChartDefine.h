//
//  GGChartDefine.h
//  111
//
//  Created by _ | Durex on 2017/5/19.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#ifndef GGChartDefine_h
#define GGChartDefine_h

#define AAPropStatementAndFuncStatement(propertyModifyWord,className, propertyPointerType, propertyName)                \
@property(nonatomic,propertyModifyWord)propertyPointerType  propertyName;                                               \
- (className * (^) (propertyPointerType propertyName)) propertyName##Set;

#define AAPropSetFuncImplementation(className, propertyPointerType, propertyName)                                       \
- (className * (^) (propertyPointerType propertyName))propertyName##Set{                                                \
return ^(propertyPointerType propertyName) {                                                                            \
self.propertyName = propertyName;                                                                                       \
return self;                                                                                                            \
};                                                                                                                      \
}

#define GG_INIT(A)  - (instancetype)init             \
                    {                                \
                        self = [super init];         \
                        if (self)  A                 \
                        return self;                 \
                    }

#define GGObject(objectName)        [[objectName alloc]init]
#define GGPoint(x, y)               [NSValue valueWithCGPoint:CGPointMake(x, y)]


#endif /* GGChartDefine_h */
