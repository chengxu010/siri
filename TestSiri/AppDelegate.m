//
//  AppDelegate.m
//  TestSiri
//
//  Created by dongzhiqiang on 2018/12/13.
//  Copyright © 2018 dongzhiqiang. All rights reserved.
//

#import "AppDelegate.h"
#import <Intents/Intents.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [INPreferences requestSiriAuthorization:^(INSiriAuthorizationStatus status) {
        NSLog(@"");
    }];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler{
    
    NSArray *workoutArr = [userActivity.title componentsSeparatedByString:@"_"];
    
    NSString *workoutName = workoutArr[1];
    NSString *workoutStatus = workoutArr[0];
    
    NSDictionary *workout = [[NSDictionary alloc]initWithObjectsAndKeys:
                             workoutName,   @"workoutName",
                             workoutStatus, @"workoutStatus",
                             nil];
    
    //创建一个消息对象
    NSNotification *notice = [NSNotification notificationWithName:@"siri" object:nil userInfo:workout];
    //发送消息
    [[NSNotificationCenter defaultCenter]postNotification:notice];
    
    return YES;
}

- (void)getWorkoutInSiri{
    
    //接收通知
    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
    //添加观察者
    [center addObserver:self selector:@selector(getSiriInfo:) name:@"siri" object:nil];
}

- (void)getSiriInfo:(NSNotification*)info{
    
    NSLog(@"getSiriInfo = %@",info.userInfo);
}

//- (void)getWorkoutInSiri:(CDVInvokedUrlCommand *)command{
//    
//    self.callBackId = command.callbackId;
//    
//    //接收通知
//    NSNotificationCenter * center = [NSNotificationCenter defaultCenter];
//    //添加观察者
//    [center addObserver:self selector:@selector(getSiriInfo:) name:@"siri" object:nil];
//}
//
//- (void)getSiriInfo:(NSNotification*)info{
//    
//    NSLog(@"getSiriInfo = %@",info.userInfo);
//    
//    // send js callback
//    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:info.userInfo];
//    [result setKeepCallbackAsBool:YES];
//    [self.commandDelegate sendPluginResult:result callbackId:self.callBackId];
//}



@end
