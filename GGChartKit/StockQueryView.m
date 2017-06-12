//
//  StockQueryView.m
//  HSCharts
//
//  Created by 黄舜 on 17/6/12.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "StockQueryView.h"

#define GGLazyGetMethod(type, attribute)            \
- (type *)attribute                                 \
{                                                   \
if (!_##attribute) {                            \
_##attribute = [[type alloc] init];         \
}                                               \
return _##attribute;                            \
}

#define Lable_Key    [NSString stringWithFormat:@"%zd", tag]

@implementation QueryData

@end

@interface StockQueryView ()

@property (nonatomic, strong) NSMutableDictionary * dicLable;

@end

@implementation StockQueryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        _interval = 3;
        _textFont = [UIFont systemFontOfSize:9];
        _width = 120;
    }
    
    return self;
}

- (UILabel *)getLableWithTag:(NSInteger)tag
{
    UILabel * lable = [self.dicLable objectForKey:Lable_Key];
    
    if (!lable) {
        
        lable = [[UILabel alloc] init];
        [self.dicLable setObject:lable forKey:Lable_Key];
    }
    
    return lable;
}

- (void)setAryData:(NSArray<QueryData *> *)aryData
{
    _aryData = aryData;
    
    CGFloat height = [@"1" sizeWithAttributes:@{NSFontAttributeName : _textFont}].height;
    _size = CGSizeMake(_width, height * aryData.count + _interval * (aryData.count + 2));
    
    [self.dicLable enumerateKeysAndObjectsUsingBlock:^(id key, UILabel * obj, BOOL * stop) {
        
        [obj removeFromSuperview];
    }];
    
    for (NSInteger i = 0; i < aryData.count ; i++) {
        
        QueryData * data = aryData[i];
        
        NSInteger t_tag = i * 2;
        NSInteger v_tag = i * 2 + 1;
        
        UILabel *t_lable = [self getLableWithTag:t_tag];
        t_lable.font = _textFont;
        t_lable.frame = CGRectMake(0, _interval * (i + 1) + height * i, _width, height);
        t_lable.text = [NSString stringWithFormat:@" %@", data.key];
        t_lable.textAlignment = NSTextAlignmentLeft;
        t_lable.textColor = data.keyColor;
        [self addSubview:t_lable];
        
        UILabel *v_lable = [self getLableWithTag:v_tag];
        v_lable.font = _textFont;
        v_lable.frame = CGRectMake(0, _interval * (i + 1) + height * i, _width - 5, height);
        v_lable.text = [NSString stringWithFormat:@"%@", data.value];
        v_lable.textAlignment = NSTextAlignmentRight;
        v_lable.textColor = data.valueColor;
        [self addSubview:v_lable];
    }
}

GGLazyGetMethod(NSMutableDictionary, dicLable);

@end
