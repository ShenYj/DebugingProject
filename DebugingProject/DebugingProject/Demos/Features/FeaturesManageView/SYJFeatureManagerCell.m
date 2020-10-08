//
//  SYJFeatureManagerCell.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/15.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJFeatureManagerCell.h"

@interface SYJFeatureManagerCell ()

@property (nonatomic, strong) UIImageView   *featureImageView;
@property (nonatomic, strong) UILabel       *featureLabel;
@property (nonatomic, strong) UIButton      *editButton;

@end

@implementation SYJFeatureManagerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupFeatureManagerCell];
    }
    return self;
}

- (void)setupFeatureManagerCell
{
    self.clipsToBounds = YES;
    [self.contentView addSubview:self.featureImageView];
    [self.contentView addSubview:self.featureLabel];
    [self.contentView addSubview:self.editButton];
    
    CGFloat itemWidth = (SCREEN_WIDTH - 80) / 4;
    
    [self.featureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(self.contentView).mas_offset(itemWidth * 0.7);
    }];
    [self.featureLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.featureImageView.mas_bottom);
    }];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.right.mas_equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(itemWidth);
    }];
    
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setModel:(SYJFeatureManagerModel *)model indexPaht:(NSIndexPath *)indexPath exist:(BOOL)exist
{
    if (_model != model) {
        self.featureLabel.text = model.title;
        if (indexPath.section == 0) {
            [self.editButton setBackgroundImage:[UIImage imageNamed:@"life_reduce"] forState:UIControlStateNormal];
            self.editButton.userInteractionEnabled = YES;
        } else {
            if (exist) {
                [self.editButton setBackgroundImage:[UIImage imageNamed:@"life_exist"] forState:UIControlStateNormal];
                self.editButton.userInteractionEnabled = NO;
            } else {
                [self.editButton setBackgroundImage:[UIImage imageNamed:@"life_add"] forState:UIControlStateNormal];
                self.editButton.userInteractionEnabled = YES;
            }
        }
    }
    _model = model;
}

- (void)setDataAry:(NSMutableArray *)dataAry groupAry:(NSMutableArray *)groupAry indexPath:(NSIndexPath *)indexPath
{
    SYJFeatureManagerModel *model;
    if (indexPath.section == 0) {
        model = dataAry[indexPath.row];
    } else {
        model = groupAry[indexPath.row];
    }
    self.featureLabel.text = model.title;
    if (indexPath.section == 0) {
        self.editButton.userInteractionEnabled = YES;
        [self.editButton setBackgroundImage:[UIImage imageNamed:@"life_reduce"] forState:UIControlStateNormal];
    } else {
        if ([dataAry containsObject:model]) {
            self.editButton.userInteractionEnabled = NO;
            [self.editButton setBackgroundImage:[UIImage imageNamed:@"life_exist"] forState:UIControlStateNormal];
        } else {
            self.editButton.userInteractionEnabled = YES;
            [self.editButton setBackgroundImage:[UIImage imageNamed:@"life_add"] forState:UIControlStateNormal];
        }
    }
}


- (void)setInEditState:(BOOL)inEditState
{
    if (inEditState && _inEditState != inEditState) {
        self.layer.borderWidth = 0.5;
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.editButton.hidden = NO;
    } else {
        self.layer.borderColor = [UIColor clearColor].CGColor;
        self.editButton.hidden = YES;
    }
}

#pragma mark - target

- (void)targetEditButton:(UIButton *)sender event:(UIEvent *)event
{
    if (self.editTargetBlock) {
        self.editTargetBlock(sender, event);
    }
}

#pragma mark - lazy

- (UIImageView *)featureImageView {
    if (!_featureImageView) {
        _featureImageView             = [[UIImageView alloc] init];
        _featureImageView.image       = [UIImage imageNamed:@"icon"];
        _featureImageView.contentMode = UIViewContentModeScaleAspectFit;
        _featureImageView.clipsToBounds = YES;
    }
    return _featureImageView;
}
- (UILabel *)featureLabel {
    if (!_featureLabel) {
        _featureLabel               = [[UILabel alloc] init];
        _featureLabel.textAlignment = NSTextAlignmentCenter;
        _featureLabel.font          = [UIFont systemFontOfSize:15];
        _featureLabel.textColor     = [UIColor blackColor];
        _featureLabel.backgroundColor = [UIColor orangeColor];
        _featureLabel.text          = @"demo";
    }
    return _featureLabel;
}
- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [[UIButton alloc] init];
        [_editButton addTarget:self
                        action:@selector(targetEditButton:event:)
              forControlEvents:UIControlEventTouchUpInside];
    }
    return _editButton;
}

@end
