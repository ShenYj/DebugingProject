//
//  SYJCollectionViewCell.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/7.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJCollectionViewCell.h"

@interface SYJCollectionViewCell ()

@property (nonatomic, strong) UIButton *deleteButton;

@end

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
    self.layer.borderColor = [UIColor orangeColor].CGColor;
    [self.contentView addSubview:self.label];
    [self.contentView addSubview:self.deleteButton];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(20, 20));
        make.top.right.mas_equalTo(self.contentView);
    }];
}

- (void)setIsEditing:(BOOL)isEditing
{
    _isEditing = isEditing;
    if (isEditing) {
        self.deleteButton.hidden = NO;
    }
    else {
        self.deleteButton.hidden = YES;
    }
}

#pragma mark - target

- (void)targetDelete:(UIButton *)sender
{
    NSLog(@"%s", __func__);
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

- (UIButton *)deleteButton {
    if (!_deleteButton) {
        _deleteButton = [[UIButton alloc] init];
        [_deleteButton setTitle:@"x" forState:UIControlStateNormal];
        [_deleteButton addTarget:self action:@selector(targetDelete:) forControlEvents:UIControlEventTouchUpInside];
        _deleteButton.backgroundColor = [UIColor redColor];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }
    return _deleteButton;
}

@end
