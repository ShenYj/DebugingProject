//
//  AppDelegate.m
//  DebugingProject
//
//  Created by ShenYj on 2019/11/23.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "AppDelegate.h"
#import "SYJShortcutItemManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    if (IOS_VERSION < 13.0) {
        UIViewController *rootVC = [[UIViewController alloc] init];
        UINavigationController *rootTabController = [[UINavigationController alloc] initWithRootViewController:rootVC];
        self.window = [[UIWindow alloc] initWithFrame:SCREEN_BOUNDS];
        self.window.rootViewController = rootTabController;
        [self.window makeKeyAndVisible];
    }
    // 初始化3D Touch 标签
    [[SYJShortcutItemManager sharedManager] initializeShortcutItems];
    return YES;
}


// 3D Touch 标签跳转
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    [[SYJShortcutItemManager sharedManager] application:application performActionForShortcutItem:shortcutItem completionHandler:completionHandler];
}


#pragma mark - UISceneSession lifecycle

#pragma clang push
#pragma clang diagnostic ignored "-Wunguarded-availability-new"
- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options  API_AVAILABLE(ios(13.0)){
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions  API_AVAILABLE(ios(13.0)){
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}
#pragma clang pop

@end
