//
//  GYFuncManagementLastSectionFooterView.m
//  GyyxApp
//
//  Created by Shen on 2020/3/16.
//  Copyright © 2020 gyyx. All rights reserved.
//

#import "GYFuncManagementLastSectionFooterView.h"

@interface GYFuncManagementLastSectionFooterView ()

@property (nonatomic, strong) UILabel *noMoreLabel;

@end

@implementation GYFuncManagementLastSectionFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpNoMoreFooterView];
    }
    return self;
}

- (void)setUpNoMoreFooterView
{
    self.backgroundColor = COMMON_SCHEME_GRAY_COLOR;
    [self addSubview:self.noMoreLabel];
    [self.noMoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - lazy

- (UILabel *)noMoreLabel {
    if (!_noMoreLabel) {
        _noMoreLabel                = [[UILabel alloc] init];
        _noMoreLabel.text           = @"- 到底啦 -";
        _noMoreLabel.textColor      = [UIColor grayColor];
        _noMoreLabel.font           = [UIFont systemFontOfSize:15];
        _noMoreLabel.textAlignment  = NSTextAlignmentCenter;
    }
    return _noMoreLabel;
}

@end
