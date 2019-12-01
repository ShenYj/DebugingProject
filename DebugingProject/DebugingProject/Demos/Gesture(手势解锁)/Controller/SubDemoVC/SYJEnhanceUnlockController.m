//
//  SYJEnhanceUnlockController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJEnhanceUnlockController.h"

#import "SYJGestureView.h"
#import "SYJGestureConst.h"
#import "SYJGesturePreview.h"
#import "SYJGestureItemView.h"
#import "SYJGestureVerifyLabel.h"


@interface SYJEnhanceUnlockController () <SYJGestureViewDelegate>

/**
 *  重设按钮
 */
@property(nonatomic, strong) UIButton *resetBtn;

/**
 *  提示Label
 */
@property(nonatomic, strong) SYJGestureVerifyLabel *msgLabel;

/**
 *  解锁界面
 */
@property(nonatomic, strong) SYJGestureView *unLockView;

/**
 *  infoView
 */
@property(nonatomic, strong) SYJGesturePreview *infoView;

@end

@implementation SYJEnhanceUnlockController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setEnhanceUnlockView];
}

- (void)setEnhanceUnlockView
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.unLockView];
    
}

#pragma mark - SYJGestureViewDelegate




#pragma mark - lazy

- (SYJGestureView *)unLockView {
    if (!_unLockView) {
        _unLockView = [[SYJGestureView alloc] init];
        _unLockView.delegate = self;
    }
    return _unLockView;
}

@end
