//
//  ArtShareContentView.h
//  LWShareView
//
//  Created by LeeWong on 2018/1/9.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const kShareIcon;
UIKIT_EXTERN NSString * const kShareTitle;
UIKIT_EXTERN NSString * const kShareType;

@interface LWShareContentView : UIView

//防止按钮的数组 
@property (nonatomic, strong) NSArray *topMenus;
@property (nonatomic, strong) NSArray *bottomMenus;
@property (nonatomic, copy) void (^shareBtnClickBlock)(NSIndexPath *index, NSString *shareTypeStr);

@end
