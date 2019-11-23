//
//  SYJShortcutItemManager.m
//  DebugingProject
//
//  Created by ShenYj on 2019/11/23.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJShortcutItemManager.h"


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


- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"
    UIViewController *rootViewControoler = application.keyWindow.rootViewController;
#pragma clang diagnostic pop
    //    shortcutItem.localizedTitle
    if ([shortcutItem.type isEqualToString:@"ScanQRCode"]) {
        NSLog(@"ScanQRCode");
    }
    else {
        
    }
}


@end
