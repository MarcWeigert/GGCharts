//
//  CrissCrossQueryView.m
//  GGCharts
//
//  Created by _ | Durex on 17/7/6.
//  Copyright © 2017年 I really is a farmer. All rights reserved.
//

#import "CrissCrossQueryView.h"

#define Lable_Key    [NSString stringWithFormat:@"%zd", tag]

#pragma mark - 查价框

@interface QueryView ()

@property (nonatomic, strong) NSMutableDictionary * dicLable;

@end

@implementation QueryView

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

- (void)setQueryData:(id<QueryViewAbstract>)queryData
{
    _queryData = queryData;
    
    NSDictionary * valueColorDictionary = [queryData queryValueForColor];
    NSDictionary * keyColorDictionary = [queryData queryKeyForColor];
    NSArray <NSDictionary *> * keyValueArray = queryData.valueForKeyArray;
    
    CGFloat height = [@"1" sizeWithAttributes:@{NSFontAttributeName : _textFont}].height;
    _size = CGSizeMake(_width, height * keyValueArray.count + _interval * (keyValueArray.count + 2));
    
    [keyValueArray enumerateObjectsUsingBlock:^(NSDictionary * obj, NSUInteger idx, BOOL * stop) {
        
        NSInteger t_tag = idx * 2;
        NSInteger v_tag = idx * 2 + 1;
        
        UILabel *t_lable = [self getLableWithTag:t_tag];
        t_lable.font = _textFont;
        t_lable.frame = CGRectMake(0, _interval * (idx + 1) + height * idx, _width, height);
        t_lable.text = [NSString stringWithFormat:@" %@", obj.allKeys.firstObject];
        t_lable.textAlignment = NSTextAlignmentLeft;
        t_lable.textColor = keyColorDictionary[obj.allKeys.firstObject];
        [self addSubview:t_lable];
        
        UILabel *v_lable = [self getLableWithTag:v_tag];
        v_lable.font = _textFont;
        v_lable.frame = CGRectMake(0, _interval * (idx + 1) + height * idx, _width - 5, height);
        v_lable.text = [NSString stringWithFormat:@"%@", obj.allValues.firstObject];
        v_lable.textAlignment = NSTextAlignmentRight;
        v_lable.textColor = valueColorDictionary[obj.allValues.firstObject];
        [self addSubview:v_lable];
    }];
}

GGLazyGetMethod(NSMutableDictionary, dicLable);

@end

#pragma mark - 查价视图

@interface CrissCrossQueryView ()

@property (nonatomic, strong) GGStringRenderer * xAxisLable;
@property (nonatomic, strong) GGStringRenderer * yAxisLable;

@property (nonatomic, strong) GGLineRenderer * xLine;
@property (nonatomic, strong) GGLineRenderer * yLine;

@property (nonatomic, assign) BOOL isNeedAnimation;

@end

@implementation CrissCrossQueryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.userInteractionEnabled = NO;
        self.layer.masksToBounds = YES;
        
        _cirssLayer = [[GGCanvas alloc] init];
        _cirssLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        _cirssLayer.isCloseDisableActions = YES;
        
        _lineWidth = .5f;
        _cirssLableColor = [UIColor blackColor];
        _cirssLineColor = RGB(125, 125, 125);
        _cirssLableBackColor = RGB(125, 125, 125);
        _cirssLableFont = [UIFont systemFontOfSize:8];
        
        _xAxisLable = [[GGStringRenderer alloc] init];
        _xAxisLable.font = _cirssLableFont;
        _xAxisLable.color = _cirssLableColor;
        _xAxisLable.fillColor = RGB(235, 235, 235);
        _xAxisLable.offSetRatio = GGRatioBottomCenter;
        _xAxisLable.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        
        _yAxisLable = [[GGStringRenderer alloc] init];
        _yAxisLable.font = _cirssLableFont;
        _yAxisLable.color = _cirssLableColor;
        _yAxisLable.fillColor = RGB(235, 235, 235);
        _yAxisLable.offSetRatio = GGRatioCenterRight;
        _yAxisLable.edgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        
        _xLine = [[GGLineRenderer alloc] init];
        _xLine.width = _lineWidth;
        _xLine.color = _cirssLineColor;
        
        _yLine = [[GGLineRenderer alloc] init];
        _yLine.width = _lineWidth;
        _yLine.color = _cirssLineColor;
        [self.layer addSublayer:_cirssLayer];
        
        _queryView = [[QueryView alloc] initWithFrame:CGRectZero];
        _queryView.backgroundColor = [UIColor whiteColor];
        _queryView.layer.borderColor = _cirssLineColor.CGColor;
        _queryView.layer.borderWidth = _lineWidth / 2;
        [self addSubview:_queryView];
        
        [_cirssLayer addRenderer:_xLine];
        [_cirssLayer addRenderer:_yLine];
        [_cirssLayer addRenderer:_xAxisLable];
        [_cirssLayer addRenderer:_yAxisLable];
    }
    
    return self;
}

- (void)setHidden:(BOOL)hidden
{
    [super setHidden:hidden];
    
    if (hidden) {
        
        [_cirssLayer removeAllRenderer];
        [_cirssLayer setNeedsDisplay];
        
        _isNeedAnimation = NO;
    }
    else {
        
        [_cirssLayer addRenderer:_xLine];
        [_cirssLayer addRenderer:_yLine];
        [_cirssLayer addRenderer:_xAxisLable];
        [_cirssLayer addRenderer:_yAxisLable];
        [_cirssLayer setNeedsDisplay];
    }
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _cirssLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
}

- (void)setYString:(NSString *)ystring setXString:(NSString *)xString
{
    if (ystring.length) { _yAxisLable.string = ystring; }
    
    if (xString.length) { _xAxisLable.string = xString; }
}

/** 设置中心点 */
- (void)setCenterPoint:(CGPoint)center
{
    _xLine.line = GGLineRectForX(_cirssLayer.frame, center.x);
    _yLine.line = GGLineRectForY(_cirssLayer.frame, center.y);
    [_cirssLayer setNeedsDisplay];
    
    _yAxisLable.point = CGPointMake(_yAxisOffsetX, center.y);
    _xAxisLable.point = CGPointMake(center.x + _lineWidth, _xAxisOffsetY);
    
    [self updateQueryLayerWithCenter:center];
}

- (void)updateQueryLayerWithCenter:(CGPoint)center
{
    CGRect pushBeforeRect;
    CGRect pushAfterRect;
    
//    _yAxisLable.verticalRange = GGSizeRangeMake(CGRectGetMaxY(self.frame), CGRectGetMinY(self.frame));
    _xAxisLable.horizontalRange = GGSizeRangeMake(CGRectGetMaxX(self.frame), CGRectGetMinX(self.frame));
    
    BOOL isLeft = NO;
    
    if (center.x < CGRectGetMinX(self.frame) + self.queryView.width) {
        
        pushBeforeRect = CGRectMake(CGRectGetMaxX(self.frame), 0, self.queryView.size.width, self.queryView.size.height);
        pushAfterRect = CGRectMake(CGRectGetMaxX(self.frame) - self.queryView.width, 0, self.queryView.size.width, self.queryView.size.height);
    }
    else if (center.x >= CGRectGetMaxX(self.frame) - self.queryView.width) {
        
        isLeft = YES;
        
        pushBeforeRect = CGRectMake(-self.queryView.size.width, 0, self.queryView.size.width, self.queryView.size.height);
        pushAfterRect = CGRectMake(0, 0, self.queryView.size.width, self.queryView.size.height);
    }
    else {
        
        pushAfterRect = self.queryView.frame;
        pushBeforeRect = self.queryView.frame;
        
        // 初始化在左边优先
        if (CGRectEqualToRect(pushAfterRect, CGRectZero)) {
            
            pushBeforeRect = CGRectMake(-self.queryView.size.width, 0, self.queryView.size.width, self.queryView.size.height);
            pushAfterRect = CGRectMake(0, 0, self.queryView.size.width, self.queryView.size.height);
        }
    }
    
    if (CGRectEqualToRect(self.queryView.frame, pushAfterRect)) { return; }
    
    self.queryView.frame = pushAfterRect;
    
    if (_isNeedAnimation) {
        
        @autoreleasepool {
            
            CATransition *animation = [CATransition animation];
            [animation setDuration:0.35];
            animation.type = kCATransitionPush;
            animation.subtype = isLeft ? kCATransitionFromLeft:kCATransitionFromRight;
            [self.queryView.layer addAnimation:animation forKey:@"frame"];
        }
    }
    
    _isNeedAnimation = YES;
}

@end
