//
//  SYJCollectionHeaderView.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/4.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJCollectionHeaderView.h"

@interface SYJCollectionHeaderView ()



@end

@implementation SYJCollectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCollectionView];
    }
    return self;
}

- (void)setupCollectionView
{
    self.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                           green:arc4random() % 256 / 255.0
                                            blue:arc4random() % 256 / 255.0
                                           alpha:1.0];
    
    [self addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self);
        make.left.mas_equalTo(self).mas_offset(10);
        make.right.mas_equalTo(self).mas_offset(-10);
    }];
}

#pragma mark - lazy

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14];
        _label.textColor = [UIColor blackColor];
    }
    return _label;
}

@end
