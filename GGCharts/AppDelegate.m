//
//  AppDelegate.m
//  HSCharts
//
//  Created by 黄舜 on 16/6/23.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "AppDelegate.h"
#import "ListVC.h"
#import "GGGraphics.h"

#import "PieDataSet.h"
#import "Colors.h"

#import "PieCanvas.h"

#import "NSAttributedString+GGChart.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UIViewController alloc]init];
    [self.window makeKeyAndVisible];
    
    UINavigationController * navi =  [[UINavigationController alloc] initWithRootViewController:[ListVC new]];
    [self.window setRootViewController:navi];
    
    
//    NSArray * colors = @[__RGB_RED, __RGB_BLUE, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN, __RGB_GRAY, __RGB_BLUE, __RGB_PINK];
//    NSArray * pieColors = @[C_HEX(0xF04D00), C_HEX(0xFBD439), C_HEX(0x23AADA)];
//    NSArray * gradAryColors = @[@[C_HEX(0xFFB04F), C_HEX(0xF96B46)], @[C_HEX(0xFFE70E), C_HEX(0xFFF283)], @[C_HEX(0x0ECFFF), C_HEX(0x84E3FD)]];
//    NSArray * attrbuteString = @[[NSAttributedString pieChartWeightAttributeStringWith:@"业绩" nameColor:C_HEX(0xF04D00) title:@"市场业绩财报很好" fractional:@"（满分60.5）"],
//                                 [NSAttributedString pieChartWeightAttributeStringWith:@"估值" nameColor:C_HEX(0xFBD439) title:@"估值有极强吸引力" fractional:@"（满分13.5）"],
//                                 [NSAttributedString pieChartWeightAttributeStringWith:@"市场" nameColor:C_HEX(0x23AADA) title:@"市场情绪中性" fractional:@"（满分26）"]];
//    
//    GGPieData * pie = [[GGPieData alloc] init];
//    pie.radiusRange = GGRadiusRangeMake(34, 34 + 59);
//    pie.showOutLableType = OutSideShow;
//    pie.roseType = RoseRadius;
//    pie.dataAry = @[@45, @22, @33];
//    pie.outSideLable.stringRatio = CGPointMake(-1, -.5f);
//    pie.outSideLable.stringOffSet = CGSizeMake(-3, -2);
////    pie.dataAry = @[@10, @5, @15, @25, @20, @35, @30, @40];
//    
//    [pie setPieColorsForIndex:^UIColor *(NSInteger index, CGFloat ratio) {
//        
//        return colors[index];
//    }];
//    
//    [pie setGradientColorsForIndex:^NSArray<UIColor *> *(NSInteger index) {
//        
//        return gradAryColors[index];
//    }];
//        
//    pie.outSideLable.lineLength = 10;
//    pie.outSideLable.inflectionLength = 90;
//    pie.outSideLable.linePointRadius = 1.5;
//    
//    pie.showInnerString = YES;
//    pie.innerLable.stringOffSet = CGSizeMake(-.5, 0);
//    
//    [pie.outSideLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat ratio) {
//        
//        return attrbuteString[index];
//    }];
//    
//    [pie.outSideLable setLineColorsBlock:^UIColor *(NSInteger index, CGFloat ratio) {
//        
//        return pieColors[index];
//    }];
//    
//    [pie.innerLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat ratio) {
//        
//        return [NSAttributedString pieInnerStringWithLargeString:@[@"58", @"8", @"13"][index] smallString:@"分"];
//    }];
//    
//    PieDataSet * pieDataSet = [[PieDataSet alloc] init];
//    pieDataSet.pieAry = @[pie];
//    [pieDataSet updateChartConfigs:CGRectZero];
//    
//    PieCanvas * pieCanvas = [[PieCanvas alloc] init];
//    pieCanvas.frame = CGRectMake(0, 50, [UIScreen mainScreen].bounds.size.width, 400);
//    pieCanvas.pieCanvasConfig = pieDataSet;
//    pieCanvas.backgroundColor = [UIColor whiteColor].CGColor;
//    
//    [pieCanvas drawChart];
//    
//    [self.window.layer addSublayer:pieCanvas];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
