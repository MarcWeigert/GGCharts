//
//  SlideTabView.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/20.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "SlideTabView.h"

@interface SlideTabView ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@property (strong, nonatomic) CALayer *redBackgroundLayer;

@end

@implementation SlideTabView

-(void)drawRedBackgroundLayer
{
    [self.redBackgroundLayer removeFromSuperlayer];
    self.redBackgroundLayer = [CALayer layer];
    self.redBackgroundLayer.anchorPoint = CGPointMake(-0.5, 0.5);
    [self.redBackgroundLayer setFrame:CGRectZero];
    self.redBackgroundLayer.backgroundColor = RGB(68, 119, 210).CGColor;
    [self.layer insertSublayer:self.redBackgroundLayer above:self.layer];
}

+ (instancetype)switchTabView:(NSArray *)arrayTitles
{
    SlideTabView *tabView = [[SlideTabView alloc] init];
    tabView.btnArray = [NSMutableArray array];
    tabView.tabCount = arrayTitles.count;
    tabView.backgroundColor = RGB(246, 246, 246);
    
    for (int i = 0; i < arrayTitles.count; i++) {
        
        UIButton *btn = [[UIButton alloc] init];
        btn.tag = 1000 + i;
        [btn setTitle:arrayTitles[i] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        [btn setTitleColor:RGB(68, 119, 210) forState:UIControlStateNormal];
        [btn addTarget:tabView action:@selector(tabBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [tabView.btnArray addObject:btn];
        [tabView addSubview:btn];
    }
    [tabView drawRedBackgroundLayer];
    
    return tabView;
}

-(void)tabBtnClicked:(UIButton *)btn
{
    NSInteger tag = btn.tag - 1000;
    
    [self setSelectedBtn:tag];
    
    if ([self.delegate respondsToSelector:@selector(tabBtnClicked:)])
    {
        [self.delegate tabBtnClicked:tag];
    }
}

-(void)setSelectedBtn:(NSInteger)index
{
    UIButton *btn = self.btnArray[index];

    self.redBackgroundLayer.position = CGPointMake(btn.frame.origin.x, self.frame.size.height - 1);
    
    [self.btnArray enumerateObjectsUsingBlock:^(UIButton * obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }];
    
    [btn setTitleColor:RGB(68, 119, 210) forState:UIControlStateNormal];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat btnWidth = self.frame.size.width / self.btnArray.count;
    CGFloat btnHeight = self.frame.size.height;
    
    for (int i = 0; i < self.btnArray.count; i++ ) {
        
        UIButton *btn = self.btnArray[i];
        [btn setFrame:CGRectMake(i * btnWidth, 0, btnWidth, btnHeight)];
    }
    
    self.redBackgroundLayer.bounds = CGRectMake(0, 3, btnWidth / 2, 3);
    
    [self setSelectedBtn:self.selectBtnIndex];
}

@end
