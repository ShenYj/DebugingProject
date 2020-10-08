//
//  SYJFeatureManagerHeaderView.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/15.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJFeatureManagerHeaderView.h"

@implementation SYJFeatureManagerHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.headLabel];
    }
    return self;
}

- (UILabel *)headLabel
{
    if (!_headLabel) {
        _headLabel = [UILabel new];
        _headLabel.font = [UIFont systemFontOfSize:16];
        _headLabel.frame = CGRectMake(16, 0, 150, 20);
    }
    return _headLabel;
}

@end
