//
//  GYFuncManagementAddCell.m
//
//
//  Created by ShenYj on 2020/3/14.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "GYFuncManagementAddCell.h"
#import "GYNormalFunctionCell.h"

@interface GYFuncManagementAddCell ()

@property (nonatomic, strong) UIButton *addButton;

@end

@implementation GYFuncManagementAddCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFuncManagementAddCell];
    }
    return self;
}

- (void)setupFuncManagementAddCell
{
    [self.contentView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.right.mas_equalTo(self.contentView);
    }];
}

- (void)setEditingState:(BOOL)editingState
{
    _editingState = editingState;
    self.addButton.hidden = !editingState;
}

#pragma mark - target

- (void)targetForAddButton:(UIButton *)sender
{
    if (self.addFunctionBlock) {
        self.addFunctionBlock(self.functionModel);
    }
}


#pragma mark - lazy

- (UIButton *)addButton {
    if (!_addButton) {
        _addButton = [[UIButton alloc] init];
        [_addButton setBackgroundImage:[UIImage imageNamed:@"feature_add"] forState:UIControlStateNormal];
        [_addButton addTarget:self action:@selector(targetForAddButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addButton;
}

@end
