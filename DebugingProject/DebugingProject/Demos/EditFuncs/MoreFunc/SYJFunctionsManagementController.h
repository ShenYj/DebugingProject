//
//  SYJFunctionsManagementController.h
//
//
//  Created by Shen on 2019/12/19.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class GYFuncConfigModel;
@interface SYJFunctionsManagementController : UIViewController

- (instancetype)initWithInitialEditing:(BOOL)editing funcConfigModel:(nullable GYFuncConfigModel *)funcConfigModel;

@end

NS_ASSUME_NONNULL_END
