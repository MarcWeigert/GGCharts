//
//  GGDataScaler.m
//  111
//
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGDataScaler.h"

GGLineChatScaler figScaler(CGFloat max, CGFloat min, CGRect rect)
{
    CGFloat dis = CGRectGetHeight(rect);
    CGFloat pix = dis / (max - min);
    
    CGFloat zero = min > 0 ? dis + rect.origin.y : dis - pix * fabs(min) + rect.origin.y;
    
    return ^(CGFloat val) {
        
        if (val < 0) {

            return zero + fabs(val) * pix;
        }
        else {
            
            if (min < 0) {
                
                return zero - fabs(val) * pix;
            }
            
            return zero - fabs(val - min) * pix;
        }
    };
}

GGLineChatScaler axiScaler(NSInteger sep, CGRect rect, CGFloat base)
{
    CGFloat interval = CGRectGetWidth(rect) / sep;
    
    return ^(CGFloat index) {
        
        return base * interval + index * interval + rect.origin.x;
    };
}
