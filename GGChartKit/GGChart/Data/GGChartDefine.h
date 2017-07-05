//
//  GGDefine.h
//  HSCharts
//
//  Created by _ | Durex on 2017/6/25.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#ifndef GGDefine_h
#define GGDefine_h

#define RGB(r,g,b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#define C_HEXA(rgbValue, alphaValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]

#define C_HEX(rgbValue) C_HEXA(rgbValue, 1.0)

#define GGLazyGetMethod(type, attribute)            \
- (type *)attribute                                 \
{                                                   \
    if (!_##attribute) {                            \
        _##attribute = [[type alloc] init];         \
    }                                               \
    return _##attribute;                            \
}

#endif /* GGDefine_h */
