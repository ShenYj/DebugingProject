//
//  SYJGestureVerifyLabel.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJGestureVerifyLabel.h"

@implementation SYJGestureVerifyLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //视图初始化
        [self viewPrepare];
    }
    return self;
}

/*
 *  视图初始化
 */
- (void)viewPrepare
{
    [self setFont:[UIFont systemFontOfSize:14.0f]];
    [self setTextAlignment:NSTextAlignmentCenter];
}


/*
 *  普通提示信息
 */
- (void)showNormalMsg:(NSString *)msg
{
    [self setText:msg];
    [self setTextColor:[UIColor blackColor]]; //textColorNormalState
}

/*
 *  警示信息
 */
- (void)showWarnMsg:(NSString *)msg
{
    [self setText:msg];
    [self setTextColor:[UIColor color:254 green:82 blue:92 alpha:1]];
}


/*
 *  警示信息(shake)
 */
- (void)showWarnMsgAndShake:(NSString *)msg
{
    [self setText:msg];
    [self setTextColor:[UIColor color:254 green:82 blue:92 alpha:1]];
    //添加一个shake动画
    [self.layer shake];
}

@end
