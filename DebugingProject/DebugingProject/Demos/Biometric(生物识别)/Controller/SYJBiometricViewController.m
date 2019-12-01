//
//  SYJBiometricViewController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/11/30.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJBiometricViewController.h"
#import "SYJBiometricManager.h"

@interface SYJBiometricViewController ()

@property (nonatomic, strong) UILabel *authenticLabel;

@property (nonatomic, strong) SYJBiometricManager *biometricManager;

@end

@implementation SYJBiometricViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupDemoView];

}
- (void)setupDemoView
{
    self.view.backgroundColor = [UIColor whiteColor];


    [self.view addSubview:self.authenticLabel];
    [self.authenticLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(150);
        make.left.mas_equalTo(self.view).mas_offset(20);
        make.right.mas_equalTo(self.view).mas_offset(-20);
    }];
    SYJBiometricType biometricType = [self.biometricManager biometricTypeForThisDevice];
    
    NSString *btnTitle = @"";
    NSString *showMsg = @"";
    if (biometricType == SYJBiometricTypeFaceID) {
        btnTitle = @"FaceID解锁";
        showMsg = @"当前设备支持解锁方式: FaceID ";
    }
    else if (biometricType == SYJBiometricTypeTouchID) {
        btnTitle = @"TouchID解锁";
        showMsg = @"当前设备支持解锁方式: TouchID ";
    }
    else {
        showMsg = @"当前设备支不支持FaceID和TouchID解锁";
    }
    self.authenticLabel.text = showMsg;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:btnTitle style:UIBarButtonItemStyleDone target:self action:@selector(biometricAuthenic:)];
    
}

- (void)biometricAuthenic:(UIBarButtonItem *)sender
{
    SYJBiometricType biometricType = [self.biometricManager biometricTypeForThisDevice];
    NSLog(@"是否支持生物识别: %@", biometricType != SYJBiometricTypeUnvailble ? @"YES" : @"NO");
    [self.biometricManager evaluatePolicy:^(BOOL isSuccess, NSString * _Nonnull message) {
        NSLog(@"结果: %@", isSuccess ? @"解锁成功": @"解锁失败");
        NSLog(@"%@", message);
        self.authenticLabel.text = [NSString stringWithFormat:@"验证结果: %@",isSuccess ? @"解锁成功": @"解锁失败"];
    }];
}


#pragma mark - lazy

- (SYJBiometricManager *)biometricManager {
    if (!_biometricManager) {
        _biometricManager = [[SYJBiometricManager alloc] init];
    }
    return _biometricManager;
}

- (UILabel *)authenticLabel {
    if (!_authenticLabel) {
        _authenticLabel = [[UILabel alloc] init];
        _authenticLabel.font = [UIFont systemFontOfSize:15];
        _authenticLabel.textColor = [UIColor orangeColor];
        _authenticLabel.contentMode = UIViewContentModeCenter;
    }
    return _authenticLabel;
}

@end


