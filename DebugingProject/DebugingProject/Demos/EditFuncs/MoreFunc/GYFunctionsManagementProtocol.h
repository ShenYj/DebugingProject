//
//  GYCustomFeaturesProtocol.h
//  
//
//  Created by Shen on 2019/12/19.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@protocol GYFunctionsManagementProtocol <NSObject>

@optional

- (void)protocolShowMessage:(NSString *)message title:(NSString *)title;

/// 提醒用户是否保存本次编辑
- (void)protocolNoticeToSave;
/// 提醒以保存 用户选择取消
- (void)protocolSelectCancel;


/// 右侧导航按钮业务: 完成编辑
- (void)protocolRightNavButtonCompletion;
/// 右侧导航按钮业务: 进入编辑状态
- (void)protocolRightNavButtonEditing;

/// 左侧导航按钮业务: 返回上一页
- (void)protocolLeftNavButtonPopToPreviousPage;
/// 左侧导航按钮业务: 提醒用户保存编辑
- (void)protocolLeftNavButtonNoticeToSave;


@end

NS_ASSUME_NONNULL_END
