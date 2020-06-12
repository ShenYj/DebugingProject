//
//  GYFuncManagementView.h
//  GyyxApp
//
//  Created by Shen on 2020/3/17.
//  Copyright © 2020 gyyx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYFuncConfigModel, GYFunctionModel;
@protocol GYFuncManagementViewDelegate <NSObject>

@optional
/// 添加功能已达到上限
- (void)funcExceededLimit;
/// 快捷入口所展示功能是否产生变化
- (void)funcConfigChanged:(BOOL)changed;
/// 非编辑状态下长按至编辑状态
- (void)funcUneditStateLongPressHandler;
/// 执行某个功能
- (void)funcExecuteFunction:(nullable GYFunctionModel *)function;
@end


@interface GYFuncManagementView : UIScrollView

// 正在编辑的状态
@property (nonatomic, assign, getter=isEditState) BOOL editState;

#pragma mark - 外部事件
// 取消编辑
- (void)cancelEdit;
// 保存
- (void)saveEdit;

// 自定义构造函数
- (instancetype)initWithFrame:(CGRect)frame funcConfigModel:(nullable GYFuncConfigModel *)funcConfigModel editState:(BOOL)editState NS_DESIGNATED_INITIALIZER;

@property (nonatomic,  weak) id <GYFuncManagementViewDelegate> fmDelegate;

@end

NS_ASSUME_NONNULL_END
