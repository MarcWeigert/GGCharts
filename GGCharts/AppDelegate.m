//
//  AppDelegate.m
//  HSCharts
//
//  Created by _ | Durex on 16/6/23.
//  Copyright © 2016年 I really is a farmer. All rights reserved.
//

#import "AppDelegate.h"
#import "ListVC.h"
#import "GGGraphics.h"

#import "PieChart.h"
#import "GGPieLayer.h"
#import "GGRuntimeHelper.h"
#include <objc/runtime.h>
#import "BaseMinimaxScaler.h"
#import "NSObject+FireBlock.h"
#import "GGNumber.h"

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
    
    //自定义返回按钮
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage new]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
//    
//    BaseMinimaxScaler * scaler = [[BaseMinimaxScaler alloc] init];
//    
//    [scaler setObjectAry:@[@2.14, @1.22, @1.223, @1.9867, @0.003, @-30.5, @100]
//    floatOrDoubleGetters:@[NSStringFromSelector(@selector(floatValue))]];
//    
//    NSDictionary * dic = @{
//                           [GGNumber numberWithFloat:2.14] : @0,
//                           [GGNumber numberWithFloat:1.22] : @0,
//                           [GGNumber numberWithFloat:1.223] : @0,
//                           [GGNumber numberWithFloat:1.9867] : @0,
//                           [GGNumber numberWithFloat:0.003] : @0,
//                           [GGNumber numberWithFloat:-30.5] : @0,
//                           [GGNumber numberWithFloat:100.1] : @0,
//                           [GGNumber numberWithFloat:100.0] : @1,
//                           [GGNumber numberWithFloat:100.0] : @1,
//                           };
//    
//    //NSDate * date1 = [NSDate date];
//    
//    for (int i = 0; i < 10000; i++) {
//        
//       NSArray * ary = dic.allKeys;
//    }
//    
//    NSDate * date2 = [NSDate date];
//    
//    //NSLog(@"%f", date1.timeIntervalSince1970 - date2.timeIntervalSince1970);
//    
//    for (int i = 0; i < 10000; i++) {
//        
//        NSArray * ary = @[@2.14, @1.22, @1.223, @1.9867, @0.003, @-30.5, @100];
//    }
//    
//    //NSLog(@"%f", date2.timeIntervalSince1970 - [NSDate date].timeIntervalSince1970);
//    
//    
//    NSLog(@"%@", dic.allKeys);
////
////    NSLog(@"%zd", [@2.14 hash]);
////    NSLog(@"%zd", [@2.14 hash]);
////    NSLog(@"%zd", [@-30.5 hash]);
////    NSLog(@"%zd", [@100.0 hash]);
    
    
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
