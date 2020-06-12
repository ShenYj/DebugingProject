//
//  GYFeatureManagerHeaderView.m
//  GyyxApp
//
//  Created by Shen on 2019/12/19.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "GYFuncManagementNormalSectionHeaderView.h"

@interface GYFuncManagementNormalSectionHeaderView ()

@end

@implementation GYFuncManagementNormalSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headLabel];
        self.backgroundColor = [UIColor whiteColor];
        [self.headLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self);
            make.left.mas_equalTo(self).mas_offset(16);
            make.right.mas_equalTo(self).mas_offset(-16);
        }];
    }
    return self;
}

- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [UILabel new];
        _headLabel.font = [UIFont boldSystemFontOfSize:16];
//        _headLabel.frame = CGRectMake(16, 5, 150, 20);
    }
    return _headLabel;
}

@end
