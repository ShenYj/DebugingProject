//
//  SYJPageController.h
//  DebugingProject
//
//  Created by ShenYj on 2020/3/21.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SYJPageController;
@protocol SYJPageControllerDataSource <NSObject>

@required
- (NSArray <__kindof UIViewController *> *)childrenControllersForPageController:(SYJPageController *)pageController;

@end

@interface SYJPageController : UIViewController

@property (nonatomic, weak) id dataSource;

@end

NS_ASSUME_NONNULL_END
