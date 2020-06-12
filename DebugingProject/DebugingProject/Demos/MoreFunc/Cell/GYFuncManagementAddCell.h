//
//  GYFuncManagementAddCell.h
//  
//
//  Created by ShenYj on 2020/3/14.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "GYNormalFunctionCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYFuncManagementAddCell : GYNormalFunctionCell

@property (nonatomic, assign) BOOL editingState;

@property (nonatomic, copy) void (^addFunctionBlock)(GYFunctionModel *addFuncModel);

@end

NS_ASSUME_NONNULL_END
