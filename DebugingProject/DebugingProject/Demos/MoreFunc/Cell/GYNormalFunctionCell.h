//
//  GYFeatureItemCell.h
//
//
//  Created by Shen on 2019/12/13.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYFunctionBaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@class GYFunctionModel;
@interface GYNormalFunctionCell : GYFunctionBaseCell

@property (nonatomic, strong, nullable) GYFunctionModel *functionModel;

@end

NS_ASSUME_NONNULL_END
