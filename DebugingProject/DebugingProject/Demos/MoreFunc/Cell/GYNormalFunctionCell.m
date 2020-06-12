//
//  GYNormalFunctionCell.m
//
//
//  Created by Shen on 2019/12/13.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "GYNormalFunctionCell.h"
#import "GYFuncConfigModel.h"

@interface GYNormalFunctionCell ()

@end

@implementation GYNormalFunctionCell

- (void)setFunctionModel:(GYFunctionModel *)functionModel
{
    _functionModel = functionModel;
    self.featureLabel.text = functionModel.functionName;
//    [self.featureImageView gyImage:functionModel.functionIcon placeHolder:@"feature_item_none"];
}

@end
