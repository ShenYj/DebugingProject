//
//  GYRemoveFunctionCell.m
//  
//
//  Created by Shen on 2020/3/16.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "GYFuncManagementRemoveCell.h"

@interface GYFuncManagementRemoveCell ()

@property (nonatomic, strong) UIButton *removeButton;

@end

@implementation GYFuncManagementRemoveCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFuncManagementRemoveCell];
    }
    return self;
}

- (void)setupFuncManagementRemoveCell
{
    [self.contentView addSubview:self.removeButton];
    [self.removeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.top.right.mas_equalTo(self.contentView);
    }];
}

- (void)setEditingState:(BOOL)editingState
{
    _editingState = editingState;
    self.removeButton.hidden = !editingState;
}

#pragma mark - target

- (void)targetForRemoveButton:(UIButton *)sender
{
    if (self.removeFunctionBlock) {
        self.removeFunctionBlock(self.functionModel);
    }
}


#pragma mark - lazy

- (UIButton *)removeButton {
    if (!_removeButton) {
        _removeButton = [[UIButton alloc] init];
        [_removeButton setBackgroundImage:[UIImage imageNamed:@"feature_delete"] forState:UIControlStateNormal];
        [_removeButton addTarget:self action:@selector(targetForRemoveButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _removeButton;
}

@end
