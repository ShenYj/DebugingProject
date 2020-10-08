//
//  ArtShareService.h
//  LWShareView
//
//  Created by LeeWong on 2018/1/10.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ShareType) {
    ShareTypeForward       = 9110,   // 转发
    ShareTypeWeChatFriends,          // 微信好友
    ShareTypeWeChatCircleOfFriends,  // 微信朋友圈
    ShareTypeWeibo,                  // 微博
    ShareTypeQQFriends,              // QQ好友
    ShareTypeQQZone,                 // QQ空间
};

@interface LWShareService : NSObject

@property (nonatomic, copy) void (^shareBtnClickBlock)(NSIndexPath *index, ShareType shareType);
@property (nonatomic, copy) void (^shareBtnCancelBlock)(void);

+ (instancetype)shared;

- (void)showInViewController:(UIViewController *)viewController;

@end
