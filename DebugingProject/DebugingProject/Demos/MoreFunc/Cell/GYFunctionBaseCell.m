//
//  GYFeatureBaseCell.m
//  
//
//  Created by Shen on 2019/12/13.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "GYFunctionBaseCell.h"


@interface GYFunctionBaseCell ()



@end

@implementation GYFunctionBaseCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupBaseItemView];
    }
    return self;
}

- (void)setupBaseItemView
{
    self.backgroundColor = COMMON_SCHEME_WHITE_COLOR;
    
    [self.contentView addSubview:self.bgImageView];
    [self.contentView addSubview:self.featureImageView];
    [self.contentView addSubview:self.featureLabel];
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
    [self.featureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.featureLabel.mas_top);
        make.centerX.mas_equalTo(self.contentView);
        make.centerY.mas_equalTo(self.contentView).mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(35, 35));
    }];
    [self.featureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.featureImageView.mas_bottom);
        make.left.bottom.right.mas_equalTo(self.bgImageView);
    }];
}

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        [self.featureImageView.layer shake];
        [self.featureLabel.layer shake];
    }
}

#pragma mark - lazy

- (UIImageView *)bgImageView {
    if (!_bgImageView) {
        _bgImageView             = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feature_item_bg"]];
        _bgImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _bgImageView;
}
- (UIImageView *)featureImageView {
    if (!_featureImageView) {
        _featureImageView             = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"feature_item_none"]];
        _featureImageView.contentMode = UIViewContentModeScaleAspectFit;
        [_featureImageView sizeToFit];
    }
    return _featureImageView;
}
- (UILabel *)featureLabel {
    if (!_featureLabel) {
        _featureLabel               = [[UILabel alloc] init];
        _featureLabel.textAlignment = NSTextAlignmentCenter;
        _featureLabel.text          = @"待添加";
        _featureLabel.font          = [UIFont systemFontOfSize:13];
    }
    return _featureLabel;
}

@end
