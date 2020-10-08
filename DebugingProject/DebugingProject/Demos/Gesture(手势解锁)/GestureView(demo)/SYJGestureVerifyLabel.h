//
//  SYJGestureVerifyLabel.h
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYJGestureVerifyLabel : UILabel

/*
 *  普通提示信息
 */
- (void)showNormalMsg:(NSString *)msg;


/*
 *  警示信息
 */
- (void)showWarnMsg:(NSString *)msg;

/*
 *  警示信息(shake)
 */
- (void)showWarnMsgAndShake:(NSString *)msg;


@end

NS_ASSUME_NONNULL_END
