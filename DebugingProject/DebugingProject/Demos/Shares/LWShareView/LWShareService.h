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
    ShareTypeForward       = 9110,
    ShareTypeWeChatFriends,
    ShareTypeWeChatCircleOfFriends,
    ShareTypeWeibo,
    ShareTypeQQFriends,
    ShareTypeQQZone,
};

@interface LWShareService : NSObject

@property (nonatomic, copy) void (^shareBtnClickBlock)(NSIndexPath *index);
@property (nonatomic, copy) void (^shareBtnCancelBlock)(void);

+ (instancetype)shared;

- (void)showInViewController:(UIViewController *)viewController;

@end
