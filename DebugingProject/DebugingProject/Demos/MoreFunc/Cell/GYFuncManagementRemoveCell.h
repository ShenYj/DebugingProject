//
//  GYRemoveFunctionCell.h
//  
//
//  Created by Shen on 2020/3/16.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "GYNormalFunctionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYFuncManagementRemoveCell : GYNormalFunctionCell

@property (nonatomic, assign) BOOL editingState;

@property (nonatomic, copy) void (^removeFunctionBlock)(GYFunctionModel *removeFuncModel);

@end

NS_ASSUME_NONNULL_END
