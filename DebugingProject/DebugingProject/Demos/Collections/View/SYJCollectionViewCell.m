//
//  SYJCollectionViewCell.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/7.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJCollectionViewCell.h"

@implementation SYJCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupCell];
    }
    return self;
}

- (void)setupCell
{
//    self.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
//                                           green:arc4random() % 256 / 255.0
//                                            blue:arc4random() % 256 / 255.0
//                                           alpha:1.0];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

#pragma mark - lazy

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.contentMode = UIViewContentModeCenter;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

@end
