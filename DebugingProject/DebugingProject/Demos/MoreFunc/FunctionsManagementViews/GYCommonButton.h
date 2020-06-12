//
//  GYCommonButton.h
//  GyyxApp
//
//  Created by Shen on 2019/12/5.
//  Copyright © 2019 gyyx. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYCommonButton : UIButton

/// 通过提供的素材图设置样式
- (instancetype)initGYButton NS_DESIGNATED_INITIALIZER;
/// 通过传参色, 以Layer实现渐变色样式
/// frame为必填参数, 并且不为CGRectZero, 否则在iOS 11之前无法正常显示
- (instancetype)initWithBGColor:(UIColor *)bgColour frame:(CGRect)frame NS_DESIGNATED_INITIALIZER;
/// 背景色白色, 自定义border颜色的定制按钮样式
- (instancetype)initWithBorderColor:(UIColor *)borderColour frame:(CGRect)fram NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
