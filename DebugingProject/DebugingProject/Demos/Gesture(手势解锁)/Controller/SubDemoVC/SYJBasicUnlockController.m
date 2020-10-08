//
//  SYJBasicUnlockController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJBasicUnlockController.h"
#import "SYJGestureUnlockView.h"

@interface SYJBasicUnlockController () <GestureUnlockViewDelegate>


@property (nonatomic, strong) SYJGestureUnlockView *gestureUnlockView;

@end

@implementation SYJBasicUnlockController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBasicUnlockView];
}

- (void)setBasicUnlockView
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Home_refresh_bg"]];

    [self.view addSubview:self.gestureUnlockView];
    [self.gestureUnlockView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.right.mas_equalTo(self.view).mas_offset(-10);
        make.height.mas_equalTo(SCREEN_WIDTH - 20);
        make.centerY.mas_equalTo(self.view);
    }];
}

#pragma mark - GestureUnlockViewDelegate

- (void)unlockPassword:(NSString *)pwd unLockView:(SYJGestureUnlockView *)unLockView
{
    NSLog(@"密码: %@", pwd);
}

#pragma mark - lazy

- (SYJGestureUnlockView *)gestureUnlockView {
    if (!_gestureUnlockView) {
        _gestureUnlockView = [[SYJGestureUnlockView alloc] init];
        _gestureUnlockView.delegate = self;
    }
    return _gestureUnlockView;
}

@end
