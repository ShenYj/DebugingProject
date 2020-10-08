//
//  SYJFeatureManagerCell.h
//  DebugingProject
//
//  Created by ShenYj on 2019/12/15.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SYJFeatureManagerModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SYJFeatureManagerCell : UICollectionViewCell

/// 是否处于编辑状态
@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, strong) SYJFeatureManagerModel *model;

@property (nullable, nonatomic, copy) void(^editTargetBlock)(UIButton *sender, UIEvent *event);


- (void)setModel:(SYJFeatureManagerModel *)model indexPaht:(NSIndexPath *)indexPath exist:(BOOL)exist;

- (void)setDataAry:(NSMutableArray *)dataAry groupAry:(NSMutableArray *)groupAry indexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
