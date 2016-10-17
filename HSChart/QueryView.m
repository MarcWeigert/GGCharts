//
//  QueryView.m
//  HSCharts
//
//  Created by 黄舜 on 16/10/17.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "QueryView.h"

@implementation UIFont (Size)

- (CGSize)sizeOfStr:(NSString *)string
{
    return [string sizeWithAttributes:@{NSFontAttributeName: self}];
}

@end

@interface QueryView ()

@property (nonatomic) UILabel *topLable;

@property (nonatomic) UILabel *bottonLable;

@end

@implementation QueryView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _topLable = [[UILabel alloc] initWithFrame:CGRectZero];;
        _topLable.textColor = [UIColor whiteColor];
        
        _bottonLable = [[UILabel alloc] initWithFrame:CGRectZero];
        _bottonLable.textColor = [UIColor whiteColor];
        
        [self addSubview:_topLable];
        [self addSubview:_bottonLable];
        
        self.layer.cornerRadius = 3;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    
    return self;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _topLable.font = font;
    _bottonLable.font = font;
}

- (void)setTitle:(NSString *)title
      classTitle:(NSString *)titleClas
       numerical:(NSString *)num
            base:(CGFloat)base
{
    NSString *strBase = [NSString stringWithFormat:@"%.2f%%", base * 100];
    NSString *content = [NSString stringWithFormat:@"%@ : %@(%@)", titleClas, num, strBase];
    
    _topLable.text = title;
    _bottonLable.text = content;
    
    CGSize size = [_font sizeOfStr:content];
    CGFloat width = size.width / 40;
    
    _topLable.frame = CGRectMake(width, width, size.width + width, size.height);
    _bottonLable.frame = CGRectMake(width, size.height + width, size.width + width, size.height);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width + width * 2, size.height * 2 + width * 2);
}

@end
