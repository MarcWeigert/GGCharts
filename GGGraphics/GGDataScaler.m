//
//  GGDataScaler.m
//  111
//
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import "GGDataScaler.h"

GGLineChatScaler figScaler(CGFloat max, CGFloat min, CGFloat dis, CGFloat base)
{
    CGFloat pix = dis / (max - min);
    
    CGFloat zero = min > 0 ? dis : dis - pix * fabs(min);
    
    return ^(CGFloat val) {
        
        if (val < 0) {

            return base + zero + fabs(val) * pix;
        }
        else {
            
            if (min < 0) {
                
                return base + zero - fabs(val) * pix;
            }
            
            return base + zero - fabs(val - min) * pix;
        }
    };
}

GGLineChatScaler axiScaler(NSInteger sep, CGFloat dis, CGFloat base)
{
    CGFloat interval = dis / sep;
    
    return ^(CGFloat index) {
        
        return base + index * interval;
    };
}
