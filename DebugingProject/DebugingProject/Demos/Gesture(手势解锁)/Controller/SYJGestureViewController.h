//
//  SYJGestureViewController.h
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum{
    GestureViewControllerTypeSetting = 1,
    GestureViewControllerTypeLogin
}GestureViewControllerType;

typedef enum{
    buttonTagReset = 1,
    buttonTagManager,
    buttonTagForget
    
}buttonTag;

@interface SYJGestureViewController : UIViewController

/**
 *  控制器来源类型
 */
@property (nonatomic, assign) GestureViewControllerType type;

@property (nonatomic, assign) NSInteger errorCount;

@end

NS_ASSUME_NONNULL_END
