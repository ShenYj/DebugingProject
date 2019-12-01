//
//  SYJGestureUnlockView.h
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@class SYJGestureUnlockView;

@protocol GestureUnlockViewDelegate <NSObject>

@optional
- (void)unlockPassword:(NSString *)pwd unLockView:(SYJGestureUnlockView *)unLockView;

@end

@interface SYJGestureUnlockView : UIView

@property (nonatomic, weak) id<GestureUnlockViewDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
