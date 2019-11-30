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

@property (nonatomic, strong) SYJBiometricManager *biometricManager;

@end

@implementation SYJBiometricViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"解锁" style:UIBarButtonItemStyleDone target:self action:@selector(biometricAuthenic:)];
}

- (void)biometricAuthenic:(UIBarButtonItem *)sender
{
    BOOL supported = [self.biometricManager authenticBiometricForThisDevice];
    NSLog(@"是否支持生物识别: %@", supported ? @"YES" : @"NO");
    [self.biometricManager evaluatePolicy:^(BOOL isSuccess, NSString * _Nonnull message) {
        NSLog(@"结果: %@", isSuccess ? @"解锁成功": @"解锁失败");
        NSLog(@"%@", message);
    }];
}


#pragma mark - lazy

- (SYJBiometricManager *)biometricManager {
    if (!_biometricManager) {
        _biometricManager = [[SYJBiometricManager alloc] init];
    }
    return _biometricManager;
}

@end


