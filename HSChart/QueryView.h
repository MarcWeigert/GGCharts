//
//  QueryView.h
//  HSCharts
//
//  Created by 黄舜 on 16/10/17.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QueryView : UIView

@property (nonatomic) UIFont *font;

/** 更新单星宇详细显示内容 */
- (void)setTitle:(NSString *)title
      classTitle:(NSString *)titleClas
       numerical:(NSString *)num
            base:(CGFloat)base;

@end
