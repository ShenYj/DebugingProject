//
//  SYJShortcutItemManager.h
//  DebugingProject
//
//  Created by ShenYj on 2019/11/23.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 扫一扫
FOUNDATION_EXTERN NSString * const kShortcutItemTypeScanQRCode;


@interface SYJShortcutItemManager : NSObject


+ (instancetype)sharedManager;
-( instancetype)init NS_UNAVAILABLE;


/*!
 *  @method application:forceTouchDidFinishLaunchingWithOptions:
 *
 *  @param application          application
 *  @param launchOptions      启动选项
 *
 *  @discussion            Home Screen Quick Actions  唤起App
 */
- (BOOL)application:(UIApplication *)application forceTouchDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

/*!
 *  @method application:performActionForShortcutItem:completionHandler:
 *
 *  @param application                     application
 *  @param shortcutItem                   shortcutItem
 *  @param completionHandler        回调
 *
 *  @discussion            App后台触发 Home Screen Quick Actions 回调
 */
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler API_AVAILABLE(ios(9.0));

@end

NS_ASSUME_NONNULL_END
