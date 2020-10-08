//
//  SYJFeatureManagerLayout.h
//  DebugingProject
//
//  Created by ShenYj on 2019/12/15.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@protocol SYJFeatureManagerDelegate <NSObject>

///  更新数据源
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath;
/// 改变编辑状态
- (void)didChangeEditState:(BOOL)inEditState;

@end

@interface SYJFeatureManagerLayout : UICollectionViewFlowLayout

/// 检测是否处于编辑状态
@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic,  weak ) id <SYJFeatureManagerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
