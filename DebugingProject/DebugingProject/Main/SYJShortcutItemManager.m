//
//  SYJShortcutItemManager.m
//  DebugingProject
//
//  Created by ShenYj on 2019/11/23.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJShortcutItemManager.h"

/// 扫一扫
NSString * const kShortcutItemTypeScanQRCode = @"HomeScreenQuickActionsScanQRCode";

static SYJShortcutItemManager * _instanceType = nil;
@implementation SYJShortcutItemManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instanceType = [[SYJShortcutItemManager alloc] init];
    });
    return _instanceType;
}

- (void)initializeShortcutItems
{
    NSMutableArray <UIApplicationShortcutItem *>*items = [NSMutableArray array];
    UIApplicationShortcutIcon *search = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeSearch];
    UIApplicationShortcutItem *searchItem = [[UIApplicationShortcutItem alloc] initWithType:@"ScanQRCode"
                                                                             localizedTitle:NSLocalizedStringFromTable(@"ScanQRCode", @"ShortcutItem", @"扫描二维码")
                                                                          localizedSubtitle:nil
                                                                                       icon:search
                                                                                   userInfo:nil];
    [items addObject:searchItem];
    [UIApplication sharedApplication].shortcutItems = items;
}




// Home Screen Quick Actions 启动App
- (BOOL)application:(UIApplication *)application forceTouchDidFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (@available(iOS 9.0, *)) {
        switch (application.delegate.window.traitCollection.forceTouchCapability) {
            case UIForceTouchCapabilityAvailable:
            {
                NSLog(@" 3D-Touch: forceTouchCapability");
                [self forceTouchConfiguration];
                return [self launchWithShortcutItem:launchOptions];
            }
                break;
            case UIForceTouchCapabilityUnavailable:
            {
                NSLog(@" 3D-Touch: UIForceTouchCapabilityUnavailable");
            }
                break;
            case UIForceTouchCapabilityUnknown:
            {
                NSLog(@" 3D-Touch: UIForceTouchCapabilityUnknown");
            }
                break;
            default:
                break;
        }
    }
    return YES;
}

- (void)forceTouchConfiguration
{
    if (@available(iOS 9.0, *)) {
        // 多一层防护
        if ([UIApplication sharedApplication].delegate.window.traitCollection.forceTouchCapability != UIForceTouchCapabilityAvailable) {
            return;
        }
        if ([UIApplication sharedApplication].shortcutItems.count == 0) {
            NSMutableArray *shortcutItems = [[NSMutableArray alloc] init];
            NSLog(@" 配置ShortcutItem ");
            // 1. 扫一扫
            NSString *scanQRCode  = NSLocalizedStringFromTable(@"ScanIt", @"Common", @"扫一扫");
            UIMutableApplicationShortcutItem *shortcutItem = [[UIMutableApplicationShortcutItem alloc] initWithType: kShortcutItemTypeScanQRCode
                                                                                                     localizedTitle: scanQRCode
                                                                                                  localizedSubtitle: nil
                                                                                                               icon: nil
                                                                                                           userInfo: nil];
            [shortcutItems addObject:shortcutItem];
            
            [UIApplication sharedApplication].shortcutItems = shortcutItems.copy;
        }
    }
}

- (BOOL)launchWithShortcutItem:(NSDictionary *)launchOption
{
    NSLog(@"%s", __func__);
    if (@available(iOS 9.0, *)) {
        UIApplicationShortcutItem *shortcutItem = [launchOption valueForKey:UIApplicationLaunchOptionsShortcutItemKey];;
        if (shortcutItem) {
            [self dealWithShortcutItem:shortcutItem completionHandler:nil];
            return NO;
        }
    }
    return YES;
}

// App后台触发 Home Screen Quick Actions 回调
- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
 API_AVAILABLE(ios(9.0)) {
    NSLog(@"%s", __func__);
    [self dealWithShortcutItem:shortcutItem completionHandler:completionHandler];
}


#pragma mark - Home Screen Quick Actions

- (void)dealWithShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^_Nullable)(BOOL))completionHandler API_AVAILABLE(ios(9.0))
{
    NSString *shortcutItemType = shortcutItem.type;
    NSLog(@" UIApplicationShortcutItem: %@ ", shortcutItemType);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    
#pragma clang diagnostic pop
    // 扫一扫
    if ([shortcutItemType isEqualToString:kShortcutItemTypeScanQRCode]) {
        NSLog(@" Home Screen Quick Actions: 扫一扫 ");
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"openQR"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return;
    }
    
}


@end
