//
//  SYJBiometricManager.m
//  DebugingProject
//
//  Created by ShenYj on 2019/11/30.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJBiometricManager.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface SYJBiometricManager ()

@property (nonatomic, strong) LAContext *authenticContext;

@end

@implementation SYJBiometricManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initManager];
    }
    return self;
}

- (void)initManager
{
    _authenticContext = [[LAContext alloc] init];
    // TouchID: localizedFallbackTitle 按钮 会在第一次指纹验证失败后出现,  点击后切换到密码解锁
    // FaceID:  第一次FaceID验证失败, 会多出"再次尝试面容ID"按钮 和 localizedCancelTitle 按钮,
    //          第二次失败后, 会显示localizedFallbackTitle 按钮
    // 如果LAPolicy 设置的是LAPolicyDeviceOwnerAuthenticationWithBiometrics , 点击后将走失败回调 kLAErrorUserFallback
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        _authenticContext.localizedFallbackTitle = NSLocalizedStringFromTable(@"Biometricc_By_Password", @"Biometric", @"手动输入密码");
    }
    else {
        _authenticContext.localizedFallbackTitle = @"";
    }
    if (@available(iOS 10.0, *)) {
        _authenticContext.localizedCancelTitle = NSLocalizedStringFromTable(@"Biometricc_Cancel_Title", @"Biometric", @"取消");
    }
}

- (BOOL)authenticBiometricForThisDevice
{
    /**   判断是否支持密码验证
     * LAPolicyDeviceOwnerAuthenticationWithBiometrics iOS 8.0以上支持，只有指纹验证功能
     * LAPolicyDeviceOwnerAuthentication                         iOS 9.0以上支持，包含Touch ID / Face ID验证与输入密码的验证方式 类似支付宝
     */
    NSError * error = nil;
    BOOL supportAuthentic = NO;
    
    if (@available(iOS 9.0, *)) {
        supportAuthentic = [self.authenticContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthentication error:&error];
        if (error) {
            NSLog(@"不支持LAPolicyDeviceOwnerAuthentication: %@", error);
        }
    }
    else {
        supportAuthentic = [self.authenticContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
        if (error) {
            NSLog(@"不支持LAPolicyDeviceOwnerAuthenticationWithBiometrics: %@", error);
        }
    }
    return supportAuthentic;
}

- (void)evaluatePolicy:(nullable void(^)(BOOL isSuccess, NSString *message))reply
{
    if (![self authenticBiometricForThisDevice]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *notAvailable = NSLocalizedStringFromTable(@"Biometric_Authen_Biometry_NotAvailable", @"Biometric", @"TouchID/FaceID 不可用");
            if (reply) reply(NO, notAvailable);
        });
        return;
    }
    
    LAPolicy policy;
    NSString *localizedReason = @"";
    if (@available(iOS 9.0, *)) {
        // 三次指纹验证失败, 可通过系统密码解锁
        policy = LAPolicyDeviceOwnerAuthentication;
        localizedReason = NSLocalizedStringFromTable(@"Biometricc_By_Password", @"Biometric", @"手动输入密码");
    } else {
        // 三次指纹验证失败, 直接失败回调
        policy = LAPolicyDeviceOwnerAuthenticationWithBiometrics;
    };
    
    [self.authenticContext evaluatePolicy:policy localizedReason:localizedReason reply:^(BOOL success, NSError * _Nullable error) {
        if (success) {
            NSString *successMsg = NSLocalizedStringFromTable(@"Biometric_Authen_Success", @"Biometric", @"解锁成功");
            dispatch_async(dispatch_get_main_queue(), ^{
                if (reply) reply(success, successMsg);
            });
        }
        else {
            /**
             #define kLAErrorAuthenticationFailed                   -1
             #define kLAErrorUserCancel                                 -2
             #define kLAErrorUserFallback                               -3
             #define kLAErrorSystemCancel                             -4
             #define kLAErrorPasscodeNotSet                         -5
             #define kLAErrorTouchIDNotAvailable                   -6
             #define kLAErrorTouchIDNotEnrolled                    -7
             #define kLAErrorTouchIDLockout                          -8
             #define kLAErrorAppCancel                                  -9
             #define kLAErrorInvalidContext                            -10
             #define kLAErrorWatchNotAvailable                     -11
             #define kLAErrorNotInteractive                             -1004
             
             #define kLAErrorBiometryNotAvailable                  kLAErrorTouchIDNotAvailable
             #define kLAErrorBiometryNotEnrolled                   kLAErrorTouchIDNotEnrolled
             #define kLAErrorBiometryLockout                         kLAErrorTouchIDLockout
             */
            NSString *reason = @"";
            switch (error.code) {
                case kLAErrorAuthenticationFailed:
                {
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_Faild", @"Biometric", @"验证失败");
                    break;
                }
                case kLAErrorUserCancel:
                {
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_User_Cancel", @"Biometric", @"取消验证");
                    break;
                }
                case kLAErrorSystemCancel:
                {
                    //  (如遇来电,锁屏,其他APP切入,按了Home键等)
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_System_Cancel", @"Biometric", @"系统中断");
                    break;
                }
                case kLAErrorAppCancel:
                {
                    // (如切换到后台) iOS 9.0
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_App_Cancel", @"Biometric", @"被App取消");
                    break;
                }
                case kLAErrorUserFallback:
                {
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_User_Cancel", @"Biometric", @"选择输入密码");
                    break;
                }
                case kLAErrorPasscodeNotSet:
                {
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_Passcode_Notset", @"Biometric", @"未启用密码锁");
                    break;
                }
                case kLAErrorBiometryNotEnrolled:
                {
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_Biometry_NotEnrolled", @"Biometric", @"未设置TouchID/FaceID");
                    break;
                }
                case kLAErrorBiometryNotAvailable:
                {
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_Biometry_NotAvailable", @"Biometric", @"TouchID/FaceID 不可用");
                    break;
                }
                case kLAErrorBiometryLockout:
                {
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_Biometry_Lockout", @"Biometric", @"多次验证失败,TouchID被锁定");
                    break;
                }
                case kLAErrorInvalidContext:
                {
                    // iOS 9.0
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_Biometry_InvalidContext", @"Biometric", @"LAContext对象无效");
                    break;
                }
                case kLAErrorNotInteractive:
                {
                    reason = NSLocalizedStringFromTable(@"Biometric_Authen_Biometry_NotInteractive", @"Biometric", @"应用处于未激活状态");
                    break;
                }
                default:
                    break;
            }
            
            NSLog(@"解锁失败: [%@]", reason);
            dispatch_async(dispatch_get_main_queue(), ^{
                if (reply) reply(success, reason);
            });
        }
    }];
}

@end
