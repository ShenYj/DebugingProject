//
//  GYFunctionModel.h
//
//
//  Created by ShenYj on 2020/3/12.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark -

@class GYFunctionGroupModel, GYFunctionModel;
@interface GYFuncConfigModel : NSObject

/// 版本
@property (nonatomic,  copy ) NSNumber  *version;
/// 当前默认选中功能的索引
@property (nonatomic, strong) NSArray <NSNumber *>  *selectedFuncIDs;
/// 全部功能数据 (按组划分)
@property (nonatomic, strong) NSArray <GYFunctionGroupModel *> *groupData;

@end


#pragma mark -

@interface GYFunctionGroupModel : NSObject

/// 功能分组的ID
@property (nonatomic,  copy ) NSNumber  *groupID;
/// 当前功能分组的标题
@property (nonatomic,  copy ) NSString  *groupTitle;
/// 该功能分组下的数据
@property (nonatomic, strong) NSArray <GYFunctionModel *>  *funcData;

@end

#pragma mark -

@interface GYFunctionModel : NSObject

/// 功能ID
@property (nonatomic, strong) NSNumber  *functionID;
/// 当前功能图标
@property (nonatomic,  copy ) NSString  *functionIcon;
/// 该功能名称
@property (nonatomic,  copy ) NSString  *functionName;

@end

NS_ASSUME_NONNULL_END
