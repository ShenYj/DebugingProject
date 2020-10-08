//
//  SYJModalViewController.h
//  DebugingProject
//
//  Created by ShenYj on 2019/11/24.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol ModalViewControllerDelegate;
@interface SYJModalViewController : UIViewController

@property (nonatomic, weak) id<ModalViewControllerDelegate> delegate;

@end


@protocol ModalViewControllerDelegate <NSObject>

- (void)modalViewControllerDidClickedDismissButton:(SYJModalViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
