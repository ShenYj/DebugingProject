//
//  ArtShareContentView.m
//  LWShareView
//
//  Created by LeeWong on 2018/1/9.
//  Copyright © 2018年 LeeWong. All rights reserved.
//

#import "LWShareContentView.h"
#import "LWShareCollectionViewCell.h"
#import "UIColor+LW.h"
#import "LWShareButton.h"
#import <Masonry.h>

NSString * const kShareIcon = @"kShareIcon";
NSString * const kShareTitle = @"kShareTitle";
NSString * const kShareType = @"kShareType";

CGFloat kMargin = 10;
CGFloat kPadding = 15;
CGFloat kFooterHeight = 30;
CGFloat kMinimumInteritemSpacing = 10;

CGFloat kItemHeight = 74;

#define kItemWidth (([UIScreen mainScreen].bounds.size.width) - kMargin * 2 - kPadding * 2-kMinimumInteritemSpacing*4) / 5

@interface LWShareContentView () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView *topCollectionView;
@property (nonatomic, strong) UICollectionView *bottomCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *topFlowLayout;
@property (nonatomic, strong) UICollectionViewFlowLayout *bottomFlowLayout;
@property (nonatomic, strong) UIView *sepLine;
@property (nonatomic, strong) UILabel *shareTipLabel;
@end

@implementation LWShareContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self buildUI];
    }
    return self;
}


#pragma mark - Build UI

- (void)buildUI
{
    [self.shareTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).offset(kPadding);
        make.centerX.equalTo(self.mas_centerX);
    }];
    
    [self.topCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.shareTipLabel.mas_bottom).offset(kPadding);
        make.left.equalTo(self.mas_left).offset(kPadding);
        make.right.equalTo(self.mas_right).offset(-kPadding);
        make.height.equalTo(@(kItemHeight));
    }];
    
    [self.sepLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(1.0/[UIScreen mainScreen].scale));
        make.left.right.equalTo(self.topCollectionView);
        make.top.equalTo(self.topCollectionView.mas_bottom).offset(kFooterHeight/2.0);
    }];
    
    [self.bottomCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-kPadding);
        make.left.right.equalTo(self.topCollectionView);
        make.top.equalTo(self.sepLine.mas_bottom);
    }];
}

- (void)setTopMenus:(NSArray *)topMenus
{
    _topMenus = topMenus;
    [self.topCollectionView reloadData];
}

- (void)setBottomMenus:(NSArray *)bottomMenus
{
    _bottomMenus = bottomMenus;
    [self.bottomCollectionView reloadData];
    self.sepLine.hidden = _bottomMenus.count == 0;
}

#pragma mark - target

- (void)clickShareItem:(UIButton *)sender
{
    LWShareButton *shareButton = (LWShareButton *)sender;
    NSIndexPath *indexPath = shareButton.indexPath;
    if (self.shareBtnClickBlock) {
        self.shareBtnClickBlock(indexPath, shareButton.shareType.copy);
    }
}


#pragma mark - UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    [collectionView.collectionViewLayout invalidateLayout];
    return self.topCollectionView == collectionView ? self.topMenus.count : self.bottomMenus.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *menus = nil;
    self.topCollectionView == collectionView ? (menus = self.topMenus) : (menus= self.bottomMenus);
    LWShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LWShareCollectionViewCell" forIndexPath:indexPath];
    NSDictionary *item = menus[indexPath.item];
    cell.shareBtn.indexPath = indexPath;
    cell.shareBtn.shareType = item[kShareType];
    [cell.shareBtn setTitle:item[kShareTitle] forState:UIControlStateNormal];
    [cell.shareBtn setImage:[UIImage imageNamed:item[kShareIcon]] forState:UIControlStateNormal];
    [cell.shareBtn addTarget:self action:@selector(clickShareItem:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}



#pragma mark - Lazy Load

- (UICollectionView *)topCollectionView
{
    if (_topCollectionView == nil) {
        _topCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.topFlowLayout];
        [self addSubview:_topCollectionView];
        [_topCollectionView registerClass:[LWShareCollectionViewCell class] forCellWithReuseIdentifier:@"LWShareCollectionViewCell"];
        _topCollectionView.backgroundColor = [UIColor clearColor];
        _topCollectionView.dataSource = self;
        _topCollectionView.delegate = self;
        _topCollectionView.showsHorizontalScrollIndicator = NO;
        _topCollectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_topCollectionView];
    }
    return _topCollectionView;
}

- (UICollectionView *)bottomCollectionView
{
    if (_bottomCollectionView == nil) {
        _bottomCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.bottomFlowLayout];
        [self addSubview:_bottomCollectionView];
        [_bottomCollectionView registerClass:[LWShareCollectionViewCell class] forCellWithReuseIdentifier:@"LWShareCollectionViewCell"];
        _bottomCollectionView.backgroundColor = [UIColor clearColor];
        _bottomCollectionView.dataSource = self;
        _bottomCollectionView.delegate = self;
        _bottomCollectionView.showsHorizontalScrollIndicator = NO;
        _bottomCollectionView.showsVerticalScrollIndicator = NO;
        [self addSubview:_bottomCollectionView];
    }
    return _bottomCollectionView;
}


- (UICollectionViewFlowLayout *)topFlowLayout
{
    if (_topFlowLayout == nil) {
        _topFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _topFlowLayout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        _topFlowLayout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
        _topFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _topFlowLayout;
}

- (UICollectionViewFlowLayout *)bottomFlowLayout
{
    if (_bottomFlowLayout == nil) {
        _bottomFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        _bottomFlowLayout.minimumInteritemSpacing = kMinimumInteritemSpacing;
        _bottomFlowLayout.itemSize = CGSizeMake(kItemWidth, kItemHeight);
        _bottomFlowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return _bottomFlowLayout;
}


- (UILabel *)shareTipLabel
{
    if (_shareTipLabel == nil) {
        _shareTipLabel = [[UILabel alloc] init];
        _shareTipLabel.font = [UIFont systemFontOfSize:17];
        _shareTipLabel.textColor = [UIColor colorWithHexString:@"333333"];
        _shareTipLabel.text = @"分享至";
        [self addSubview:_shareTipLabel];
    }
    return _shareTipLabel;
}


- (UIView *)sepLine
{
    if (_sepLine == nil) {
        _sepLine = [[UIView alloc] init];
        _sepLine.backgroundColor = [UIColor colorWithHexString:@"d9d9d9"];
        [self addSubview:_sepLine];
    }
    return _sepLine;
}

@end
