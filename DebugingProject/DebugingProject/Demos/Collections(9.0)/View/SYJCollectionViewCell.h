//
//  SYJCollectionViewCell.h
//  DebugingProject
//
//  Created by ShenYj on 2019/12/7.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SYJCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, assign) BOOL    isEditing;

@end

NS_ASSUME_NONNULL_END
