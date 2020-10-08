//
//  SYJFunctionsManagementPresenter.h
//  
//
//  Created by Shen on 2019/12/19.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJFunctionsManagementPresenter.h"


NS_ASSUME_NONNULL_BEGIN
@protocol GYFunctionsManagementProtocol;
@interface SYJFunctionsManagementPresenter : NSObject

@property (nonatomic, weak) id <GYFunctionsManagementProtocol> delegate;
- (instancetype)initWithDelegate:( nullable id <GYFunctionsManagementProtocol>)delegate;

/// 添加功能已达到上限
- (void)personAddFuncExceededLimit;

/// 提醒以保存 用户选择取消
- (void)personSelectCancel;
/// 提醒以保存 用户选择保存
- (void)personSelectSave;

/// 用户点击右侧导航按钮业务
/// isEditState -> 当前是否正处于编辑状态
- (void)personClickRightNavButton:(BOOL)isEditState;
/// 用户点击左侧导航按钮业务
/// isEditState -> 当前是否正处于编辑状态
- (void)personClickLeftNavButton:(BOOL)isEditState funcChanged:(BOOL)funcChanged;

@end

NS_ASSUME_NONNULL_END
