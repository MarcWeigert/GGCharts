//
//  TableIndexCell.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "TableIndexCell.h"

@interface TableIndexCell ()

@property (nonatomic, strong) UIView * line;

@end

@implementation TableIndexCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = RGB(190, 190, 190);
    }
    
    return self;
}

- (void)showLine:(BOOL)lineHidden
{
    _line.hidden = lineHidden;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    [self.contentView addSubview:_line];
    _line.frame = CGRectMake(5, self.contentView.frame.size.height - .5f, self.contentView.frame.size.width - 10, .5f);
}

@end
