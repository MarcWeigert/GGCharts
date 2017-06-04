//
//  GGDataScaler.h
//  111
//
//  Created by _ | Durex on 2017/6/3.
//  Copyright © 2017年 wenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef CGFloat(^GGLineChatScaler)(CGFloat record);

GGLineChatScaler figScaler(CGFloat max, CGFloat min, CGFloat dis, CGFloat base);

GGLineChatScaler axiScaler(NSInteger sep, CGFloat dis, CGFloat base);
