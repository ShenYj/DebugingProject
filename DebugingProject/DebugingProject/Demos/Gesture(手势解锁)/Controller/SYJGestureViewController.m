//
//  SYJGestureViewController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJGestureViewController.h"
#import "SYJBasicUnlockController.h"
#import "SYJEnhanceUnlockController.h"

@interface SYJGestureViewController ()

@property (nonatomic, strong) UIButton *basicUnlockButton;
@property (nonatomic, strong) UIButton *enhanceUnlockButton;

@end

@implementation SYJGestureViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI
{
    self.view.backgroundColor = [UIColor color:255 green:255 blue:255 alpha:1];
    
    [self.view addSubview:self.basicUnlockButton];
    [self.view addSubview:self.enhanceUnlockButton];
    
    [self.basicUnlockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(40);
        make.right.mas_equalTo(self.view).mas_offset(-40);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.view).mas_offset(150);
    }];
    [self.enhanceUnlockButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(40);
        make.right.mas_equalTo(self.view).mas_offset(-40);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(self.basicUnlockButton.mas_bottom).mas_offset(20);
    }];
}


#pragma mark - target

- (void)basic:(UIButton *)sender
{
    SYJBasicUnlockController *basicUnlockVC = [SYJBasicUnlockController new];
    [self.navigationController pushViewController:basicUnlockVC animated:YES];
}

- (void)enhance:(UIButton *)sender
{
    SYJEnhanceUnlockController *enhanceUnlockVC = [SYJEnhanceUnlockController new];
    [self.navigationController pushViewController:enhanceUnlockVC animated:YES];
}

#pragma mark - lazy

- (UIButton *)basicUnlockButton {
    if (!_basicUnlockButton) {
        _basicUnlockButton = [[UIButton alloc] init];
        _basicUnlockButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_basicUnlockButton setTitle:@"简单的指纹解锁" forState:UIControlStateNormal];
        [_basicUnlockButton setTitle:@"" forState:UIControlStateHighlighted];
        [_basicUnlockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_basicUnlockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_basicUnlockButton setBackgroundColor:[UIColor orangeColor]];
        _basicUnlockButton.layer.cornerRadius = 10;
        if (@available(iOS 11.0, *)) {
            _basicUnlockButton.layer.maskedCorners = UIRectCornerAllCorners;
        } else {
            _basicUnlockButton.layer.masksToBounds = YES;
        }
        [_basicUnlockButton addTarget:self action:@selector(basic:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _basicUnlockButton;
}
- (UIButton *)enhanceUnlockButton {
    if (!_enhanceUnlockButton) {
        _enhanceUnlockButton = [[UIButton alloc] init];
        _enhanceUnlockButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [_enhanceUnlockButton setTitle:@"简单的指纹解锁" forState:UIControlStateNormal];
        [_enhanceUnlockButton setTitle:@"" forState:UIControlStateHighlighted];
        [_enhanceUnlockButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_enhanceUnlockButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [_enhanceUnlockButton setBackgroundColor:[UIColor orangeColor]];
        _enhanceUnlockButton.layer.cornerRadius = 10;
        if (@available(iOS 11.0, *)) {
            _enhanceUnlockButton.layer.maskedCorners = UIRectCornerAllCorners;
        } else {
            _enhanceUnlockButton.layer.masksToBounds = YES;
        }
        [_enhanceUnlockButton addTarget:self action:@selector(enhance:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _enhanceUnlockButton;
}

@end
