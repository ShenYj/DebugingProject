//
//  SYJBiometricManager.h
//  DebugingProject
//
//  Created by ShenYj on 2019/11/30.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SYJBiometricType) {
    SYJBiometricTypeFaceID,
    SYJBiometricTypeTouchID,
    SYJBiometricTypeUnvailble,
};

//  跟相机一样需要在info.plist文件中添加配置,否则会闪退 字段: NSFaceIDUsageDescription

@interface SYJBiometricManager : NSObject

/// TouchID or FaceID or 密码验证, 内部已做了支持检查, 线程安全
- (void)evaluatePolicy:(nullable void(^)(BOOL isSuccess, NSString *message))reply;

/// 验证设备是否支持 Touch ID / Face ID 验证
- (BOOL)authenticBiometricForThisDevice;
/// 当前设备支持的生物识别类型
- (SYJBiometricType)deivceBiometricType;

@end

NS_ASSUME_NONNULL_END
