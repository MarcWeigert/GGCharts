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
    
    
//    NSArray * colors = @[__RGB_RED, __RGB_BLUE, __RGB_GREEN, __RGB_ORIGE, __RGB_CYAN];
//    
//    GGPieData * pie = [[GGPieData alloc] init];
//    pie.radiusRange = GGRadiusRangeMake(0, 50);
//    pie.showOutLableType = OutSideShow;
////    pie.roseType = RoseRadius;
//    pie.dataAry = @[@335, @310, @234, @735, @1548];
//    
//    [pie setPieColorsForIndex:^UIColor *(NSInteger index, CGFloat ratio) {
//        
//        return colors[index];
//    }];
//    
//    [pie.outSideLable setAttributeStringBlock:^NSAttributedString *(NSInteger index, CGFloat ratio) {
//        
//        return [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.2f%%", ratio * 100]];
//    }];
//    
//    PieDataSet * pieDataSet = [[PieDataSet alloc] init];
//    pieDataSet.pieAry = @[pie];
//    [pieDataSet updateChartConfigs:CGRectZero];
//    
//    PieCanvas * pieCanvas = [[PieCanvas alloc] init];
//    pieCanvas.frame = CGRectMake(10, 10, 400, 400);
//    pieCanvas.pieCanvasConfig = pieDataSet;
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
