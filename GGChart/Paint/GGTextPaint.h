//
//  GGText.h
//  HSCharts
//
//  Created by 黄舜 on 16/12/30.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "GGDrawerProtocol.h"

/** 绘制文字在点的位置 */
typedef enum : NSUInteger {
    DRAW_CENTER = 0,
    DRAW_LEFT,
    DRAW_RIGHT,
    DRAW_UPPER,
    DRAW_BOTTOM,
}DRAW_DIR;

@interface GGTextPaint : NSObject<GGLayerProtocal>

@property (nonatomic, assign) DRAW_DIR direction;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;

/** 
 * 绘制文字与点对象
 * 可覆盖初始化内容 
 */
@property (nonatomic, weak) id <GGPointProtocol> point;
@property (nonatomic, strong) NSArray<NSString *> *texts;

/** 初始化 */
+ (instancetype)textWithString:(NSString *)string point:(CGPoint)point;
+ (instancetype)textWithArray:(NSArray <NSString *>*)ary point:(id <GGPointProtocol>)point;
+ (instancetype)textWtihArray:(NSArray <NSString *>*)ary points:(NSArray <NSValue *>*)points;

@end
