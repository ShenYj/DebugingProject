//
//  SYJFunctionsManagementPresenter.m
//
//
//  Created by Shen on 2019/12/19.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJFunctionsManagementPresenter.h"
#import "GYFunctionsManagementProtocol.h"

@interface SYJFunctionsManagementPresenter ()

@end

@implementation SYJFunctionsManagementPresenter

- (instancetype)initWithDelegate:( nullable id <GYFunctionsManagementProtocol>)delegate
{
    self = [super init];
    if (self) {
        _delegate  = delegate;
    }
    return self;
}


/// 添加功能已达到上限
- (void)personAddFuncExceededLimit
{
    if ([self.delegate respondsToSelector:@selector(protocolShowMessage:title:)]) {
        [self.delegate protocolShowMessage:@"快捷功能列表已达到上限" title:@""];
    }
}

/// 提醒以保存 用户选择取消
- (void)personSelectCancel
{
    if ([self.delegate respondsToSelector:@selector(protocolSelectCancel)]) {
        [self.delegate protocolSelectCancel];
    }
}
/// 提醒以保存 用户选择保存
- (void)personSelectSave
{
    if ([self.delegate respondsToSelector:@selector(protocolRightNavButtonCompletion)]) {
        [self.delegate protocolRightNavButtonCompletion];
    }
}

/// 用户点击右侧导航按钮业务
- (void)personClickRightNavButton:(BOOL)isEditState
{
    if (isEditState) {
        // 编辑状态 --> 完成
        if ([self.delegate respondsToSelector:@selector(protocolRightNavButtonCompletion)]) {
            [self.delegate protocolRightNavButtonCompletion];
        }
        return;
    }
    // 进入编辑状态
    if ([self.delegate respondsToSelector:@selector(protocolRightNavButtonEditing)]) {
        [self.delegate protocolRightNavButtonEditing];
    }
}
/// 用户点击左侧导航按钮业务
- (void)personClickLeftNavButton:(BOOL)isEditState funcChanged:(BOOL)funcChanged
{
    if (!isEditState) {
        if ([self.delegate respondsToSelector:@selector(protocolLeftNavButtonPopToPreviousPage)]) {
            [self.delegate protocolLeftNavButtonPopToPreviousPage];
        }
        return;
    }
    if (funcChanged) {
        if ([self.delegate respondsToSelector:@selector(protocolLeftNavButtonNoticeToSave)]) {
            [self.delegate protocolLeftNavButtonNoticeToSave];
        }
        return;
    }
    if ([self.delegate respondsToSelector:@selector(protocolSelectCancel)]) {
        [self.delegate protocolSelectCancel];
    }
}

@end
