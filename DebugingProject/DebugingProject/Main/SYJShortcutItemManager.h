//
//  SYJShortcutItemManager.h
//  DebugingProject
//
//  Created by ShenYj on 2019/11/23.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYJShortcutItemManager : NSObject


+ (instancetype)sharedManager;
-( instancetype)init NS_UNAVAILABLE;

// 初始化3D Touch 标签
- (void)initializeShortcutItems;
// 3D Touch 标签触发回调
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler;
@end

NS_ASSUME_NONNULL_END
