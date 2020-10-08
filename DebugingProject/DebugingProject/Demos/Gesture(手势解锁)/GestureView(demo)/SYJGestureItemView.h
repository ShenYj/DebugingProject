//
//  SYJGestureItemView.h
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  单个圆的各种状态
 */
typedef NS_ENUM(NSUInteger, CircleState) {
    CircleStateNormal = 1,
    CircleStateSelected,
    CircleStateError,
    CircleStateLastOneSelected,
    CircleStateLastOneError
};
/**
 *  单个圆的用途类型
 */
typedef NS_ENUM(NSUInteger, CircleType) {
    CircleTypeInfo = 1,
    CircleTypeGesture
};

@interface SYJGestureItemView : UIView

/// 所处的状态
@property (nonatomic, assign) CircleState circleState;
//@property (nonatomic, assign) CircleState RcleState;
/// 类型
@property (nonatomic, assign) CircleType  type;
/// 是否有箭头 default is YES
@property (nonatomic, assign) BOOL        arrow;
/// 角度
@property (nonatomic, assign) CGFloat     angle;

@end

NS_ASSUME_NONNULL_END
