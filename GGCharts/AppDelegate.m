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
#import "KMCGeigerCounter.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
   // self.window.rootViewController = [[UIViewController alloc]init];
    
    UINavigationController * navi =  [[UINavigationController alloc] initWithRootViewController:[ListVC new]];
    [self.window setRootViewController:navi];
    
    //自定义返回按钮
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage new]
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    //将返回按钮的文字position设置不在屏幕上显示
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-100, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    
    // [self sortByHeaps:@[@1, @3, @4, @5, @2, @6, @9, @7, @8, @0, @10, @30, @1].mutableCopy];
    
    // NSMutableArray * ary = @[@6, @2, @7, @3, @8, @9].mutableCopy;
    
    // [self querySort:ary leftIndex:0 rightIndex:ary.count - 1];
    
    
    NSObject * a = [NSObject new];
    
    [a setValue:@1 forKey:@"1"];
    
	[self.window makeKeyAndVisible];
    
#if !TARGET_IPHONE_SIMULATOR
   // [KMCGeigerCounter sharedGeigerCounter].enabled = YES;
#endif
    
    //NSLog(@"%@", ary);
    
    return YES;
}

- (void)querySort:(NSMutableArray *)array leftIndex:(NSInteger)left rightIndex:(NSInteger)right
{
    if (left >= right) { return; }
    
    NSInteger i = left;
    NSInteger j = right;
    CGFloat key = [array[left] floatValue];
    
    NSInteger key_index = i;
    
    while (i < j) {
        
        while (i < j &&
               key < [array[j] floatValue]) {
            
            j--;
        }
        
        [array exchangeObjectAtIndex:key_index withObjectAtIndex:j];
        
        key_index = j;
        
        // array[i] = array[j];
        
        while (i < j &&
               key > [array[i] floatValue]) {
            
            i++;
        }
        
        [array exchangeObjectAtIndex:key_index withObjectAtIndex:i];
        
        key_index = i;
        
        // array[j] = array[i];
    }
    
    // array[i] = @(key);
    
    [self querySort:array leftIndex:left rightIndex:key_index - 1];
    [self querySort:array leftIndex:key_index + 1 rightIndex:right];
}

- (void)sortByHeaps:(NSMutableArray *)array
{
    for (NSInteger i = array.count / 2; i >= 0; i--) {
        
        [self heapFirstSort:array rootIndex:i size:array.count];
    }
    
    for (NSInteger i = array.count - 1; i >= 0; i--) {
    
        [array exchangeObjectAtIndex:0 withObjectAtIndex:i];
        
        [self heapFirstSort:array rootIndex:0 size:i];
    }
    
    NSLog(@"%@", array);
}

- (void)heapFirstSort:(NSMutableArray *)array rootIndex:(NSInteger)index size:(NSInteger)size
{
    NSInteger child = index * 2 + 1;
    
    while (child < size) {
        
        CGFloat leftNode = [array[child] floatValue];
        CGFloat rightNode = [array[child + 1] floatValue];
        CGFloat currentNode = [array[index] floatValue];
        
        if (rightNode > leftNode &&
            child + 1 < size) {
            
            child++;
        }
        
        if (currentNode > [array[child] floatValue]) {
            
            break;
        }
        else {
            
            [array exchangeObjectAtIndex:index withObjectAtIndex:child];
            
            index = child;
            child = index * 2 + 1;
        }
    }
}

//- (void)showAllSubsets:(NSMutableArray *)array start:(NSUInteger)index subAry:(NSMutableArray *)subAry
//{
//    NSMutableArray * inlineAry = subAry.mutableCopy;
//
//    for (NSInteger i = index; i < array.count; i++) {
//
//        [inlineAry addObject:array[i]];
//        [self showAllSubsets:array start:i + 1 subAry:inlineAry];
//        [inlineAry removeLastObject];
//    }
//
//    NSLog(@"%@", inlineAry);
//}
//
//- (void)showAllSubsetsMinus:(NSMutableArray *)array
//{
//    for (NSInteger i = 0; i < array.count; i++) {
//
//        NSMutableArray * inlineAry = array.mutableCopy;
//        [inlineAry removeObjectAtIndex:i];
//
//        NSLog(@"%@", inlineAry);
//
//        [self showAllSubsetsMinus:inlineAry];
//    }
//}

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
