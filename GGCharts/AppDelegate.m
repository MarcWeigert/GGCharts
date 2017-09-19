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
    
    DPieScaler * pieScaler = [[DPieScaler alloc] init];
    pieScaler.inRadius = 10;
    pieScaler.outRadius = 50;
    [pieScaler setObjAry:@[@335, @310, @234, @735, @1548] getSelector:@selector(floatValue)];
    [pieScaler updateScaler];
    
    pieScaler.pies[2].center = CGPointMake(50, 50);
    
    GGAnnular ann = GGAnnularMake(50, 50, M_PI_2, pieScaler.pies[2].arc, 10, 40);
    
    CGMutablePathRef ref = CGPathCreateMutable();
    //GGPathAddPie(ref, pieScaler.pies[2]);
    
    GGPathAddAnnular(ref, ann);
    
    CAShapeLayer * layer = [[CAShapeLayer alloc] init];
    layer.path = ref;
    layer.fillColor = [UIColor blackColor].CGColor;
    layer.frame = CGRectMake(10, 10, 100, 100);
    layer.lineWidth = 1;
    
    [self.window.layer addSublayer:layer];
    
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
