//
//  SYJFunctionsManagementController.m
//
//
//  Created by Shen on 2019/12/19.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJFunctionsManagementController.h"
#import "SYJFunctionsManagementPresenter.h"
#import "GYFunctionsManagementProtocol.h"
#import "GYFuncManagementView.h"
#import "GYCommonButton.h"
//#import "GYFunctionManager.h"
//#import "GYFuncConfigModel.h"

@interface SYJFunctionsManagementController () <GYFunctionsManagementProtocol, GYFuncManagementViewDelegate>

@property (nonatomic, strong) SYJFunctionsManagementPresenter *fmPresenter;

#pragma mark - UI
@property (nonatomic, strong) UIButton               *leftBackNavBtn;
@property (nonatomic, strong) UIButton               *leftCancelNavBtn;
@property (nonatomic, strong) GYCommonButton         *rightNavBtn;

@property (nonatomic, strong) GYFuncManagementView   *funcManagementView;

#pragma mark -

// 正在编辑的状态
@property (nonatomic, assign, getter=isEditState) BOOL editState;
// 功能区发生变更
@property (nonatomic, assign, getter=isFuncChanged) BOOL funcChanged;

// 原始数据
@property (nonatomic, strong) GYFuncConfigModel *originalFuncConfigModel;

// 展示数据
@property (nonatomic, strong) GYFuncConfigModel *disPlayFuncConfigModel;

// 已选功能集合
@property (nonatomic, strong) NSMutableArray <GYFunctionModel *>      *selectedFuncModelArray;

@end

@implementation SYJFunctionsManagementController

- (instancetype)initWithInitialEditing:(BOOL)editing funcConfigModel:(nullable GYFuncConfigModel *)funcConfigModel
{
    self = [super init];
    if (self) {
        _editState = editing;
        if (funcConfigModel) {
            _originalFuncConfigModel = funcConfigModel;
        }
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fmPresenter = [[SYJFunctionsManagementPresenter alloc] initWithDelegate:self];
    [self setupFeaturesView];
}

- (void)setupFeaturesView
{
    self.title = @"管理快捷功能";
    
    self.view.backgroundColor = COMMON_SCHEME_WHITE_COLOR;
    
    // 左侧导航按钮: 取消/ <
    UIBarButtonItem *leftItem = nil;
    if (self.isEditState) {
        leftItem = [[UIBarButtonItem alloc] initWithCustomView: self.leftCancelNavBtn];
    }
    else {
        leftItem = [[UIBarButtonItem alloc] initWithCustomView: self.leftBackNavBtn];
    }
    self.navigationItem.leftBarButtonItem = leftItem;
    // 导航右侧按钮: 编辑/完成 按钮
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView: self.rightNavBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    // 页面
    [self.view addSubview:self.funcManagementView];
}

#pragma mark - GYFunctionsManagementProtocol

/// 左侧导航按钮业务: 返回上一页
- (void)protocolLeftNavButtonPopToPreviousPage
{
    [self.navigationController popViewControllerAnimated:YES];
}
/// 左侧导航按钮业务: 提醒用户保存编辑
- (void)protocolLeftNavButtonNoticeToSave
{
    NSString *cancelStr  = NSLocalizedStringFromTable(@"Cancel", @"Common", @"取消");
    NSString *saveStr    = NSLocalizedStringFromTable(@"Save", @"Common", @"保存");
    NSString *noticeMsg  = NSLocalizedStringFromTable(@"NoticeToSaveEdit", @"Common", @"是否保存已编辑内容?");
    __weak typeof(self) weakSelf = self;
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.fmPresenter personSelectCancel];
    }];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:saveStr style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [weakSelf.fmPresenter personSelectSave];
    }];
//    [self alertWithoutInput:nil message:noticeMsg preferredStyle:UIAlertControllerStyleAlert actions:cancelAction, saveAction, nil];
}

/// 提醒以保存 用户选择取消
- (void)protocolSelectCancel
{
    self.editState = NO;
    
    [self.rightNavBtn setBackgroundColor:WHITE_COLOR];
    [_rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightNavBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];

    // 非编辑状态下返回
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: self.leftBackNavBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.funcManagementView cancelEdit];
}

/// 右侧导航按钮业务: 完成编辑
- (void)protocolRightNavButtonCompletion
{
//    [GYPureProgressHUD show];
    self.editState = NO;
    
    [self.rightNavBtn setBackgroundColor:WHITE_COLOR];
    [_rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_rightNavBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
    
    // 非编辑状态下返回
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: self.leftBackNavBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    [self.funcManagementView saveEdit];
//    [GYPureProgressHUD dismiss];
}
/// 右侧导航按钮业务: 进入编辑状态
- (void)protocolRightNavButtonEditing
{
    self.editState = YES;
    
    [self.rightNavBtn setBackgroundColor:COMMON_SCHEME_RED_COLOR];
    [_rightNavBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_rightNavBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
    
    // 编辑状态下返回按钮变为取消功能
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView: self.leftCancelNavBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark - GYFuncManagementViewDelegate

/// 添加功能已达到上限
- (void)funcExceededLimit
{
    [self.fmPresenter personAddFuncExceededLimit];
}
/// 快捷入口所展示功能是否产生变化
- (void)funcConfigChanged:(BOOL)changed
{
    self.funcChanged = changed;
    GYDebugLog(@"是否变更快捷功能列表: %d", changed);
}
/// 非编辑状态下长按至编辑状态
- (void)funcUneditStateLongPressHandler
{
    [self.fmPresenter personClickRightNavButton:self.isEditState];
    self.funcManagementView.editState = self.isEditState;
}
/// 执行某个功能
- (void)funcExecuteFunction:(nullable GYFunctionModel *)function
{
    [[GYFunctionManager shareManager] toolExecutiveFunction:function];
}

#pragma mark - target

- (void)targetForLeftNavigationButton:(UIButton *)sender
{
    [self.fmPresenter personClickLeftNavButton:self.isEditState funcChanged:self.isFuncChanged];
}

- (void)targetForRightNavigtionButton:(UIButton *)sender
{
    [self.fmPresenter personClickRightNavButton:self.isEditState];
    self.funcManagementView.editState = self.isEditState;
}

#pragma mark - lazy
- (UIButton *)leftBackNavBtn {
    if (!_leftBackNavBtn) {
        _leftBackNavBtn = [[UIButton alloc] init];
        _leftBackNavBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftBackNavBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [_leftBackNavBtn setImage:[[UIImage imageNamed:@"nav_arrow_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        [_leftBackNavBtn setImage:[[UIImage imageNamed:@"nav_arrow_back_click"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateHighlighted];
        [_leftBackNavBtn addTarget:self action:@selector(targetForLeftNavigationButton:) forControlEvents:UIControlEventTouchUpInside];
        [_leftBackNavBtn sizeToFit];
    }
    return _leftBackNavBtn;
}
- (UIButton *)leftCancelNavBtn {
    if (!_leftCancelNavBtn) {
        _leftCancelNavBtn = [[UIButton alloc] init];
        _leftCancelNavBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_leftCancelNavBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_leftCancelNavBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        [_leftCancelNavBtn addTarget:self action:@selector(targetForLeftNavigationButton:) forControlEvents:UIControlEventTouchUpInside];
        [_leftCancelNavBtn sizeToFit];
    }
    return _leftCancelNavBtn;
}
- (GYCommonButton *)rightNavBtn {
    if (!_rightNavBtn) {
        CGRect frame = CGRectMake(0, 0, 50, 30);
        _rightNavBtn = [[GYCommonButton alloc] initWithBGColor: COMMON_SCHEME_RED_COLOR frame:frame];
        _rightNavBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        if (self.isEditState) {
            [_rightNavBtn setBackgroundColor:COMMON_SCHEME_RED_COLOR];
            [_rightNavBtn setTitle:@"完成" forState:UIControlStateNormal];
            [_rightNavBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        } else {
            [_rightNavBtn setBackgroundColor:WHITE_COLOR];
            [_rightNavBtn setTitle:@"编辑" forState:UIControlStateNormal];
            [_rightNavBtn setTitleColor:BLACK_COLOR forState:UIControlStateNormal];
        }
        [_rightNavBtn addTarget:self action:@selector(targetForRightNavigtionButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightNavBtn;
}
- (GYFuncManagementView *)funcManagementView {
    if (!_funcManagementView) {
        CGRect rect = CGRectMake(0, NAVIGATION_STATUS_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATION_STATUS_HEIGHT);
        _funcManagementView = [[GYFuncManagementView alloc] initWithFrame:rect funcConfigModel:self.originalFuncConfigModel editState:self.isEditState];
        _funcManagementView.fmDelegate = self;
    }
    return _funcManagementView;
}

@end
