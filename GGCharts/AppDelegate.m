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

#import "RadarIndicatorData.h"

#import "RadarDataSet.h"
#import "RadarCanvas.h"

#import "GGRadarChart.h"

#import "LineCanvas.h"
#import "LineDataSet.h"
#import "GGLineData.h"

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
    
    GGLineData * line = [[GGLineData alloc] init];
    line.lineWidth = 1;
    line.lineColor = [UIColor redColor];
    line.lineDataAry = @[@820, @932, @901, @934, @1290, @1330, @1320];
    line.lineScaler.max = 1500;
    line.lineScaler.min = 500;
    line.shapeRadius = 3;
    line.stringFont = [UIFont systemFontOfSize:12];
    line.dataFormatter = @"%.f";
    
    LineDataSet * lineSet = [[LineDataSet alloc] init];
    lineSet.gridInside = UIEdgeInsetsMake(10, 10, 10, 10);
    lineSet.lineAry = @[line];
    
    LineCanvas * lineCanvas = [[LineCanvas alloc] init];
    lineCanvas.frame = CGRectMake(10, 10, 300, 300);
    lineCanvas.lineDrawConfig = lineSet;
    [lineCanvas drawChart];
    
    //[self.window.layer addSublayer:lineCanvas];
    
    return YES;
}

- (NSString *)stockDataJsonPath
{
    return [[NSBundle mainBundle] pathForResource:@"MA" ofType:@"lua"];
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
