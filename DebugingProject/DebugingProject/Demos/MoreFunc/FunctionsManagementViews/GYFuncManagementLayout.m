//
//  GYFuncManagementLayout.m
//  GyyxApp
//
//  Created by ShenYj on 2020/3/13.
//  Copyright © 2020 gyyx. All rights reserved.
//

#import "GYFuncManagementLayout.h"

/// 参照 标准
CGFloat const kFuncManagementItemW = 45.f;
CGFloat const kFuncManagementItemH = 33.f;

CGFloat const kFuncIPhoneRowItemCount = 3.f;
CGFloat const kFuncIPadRowItemCount   = 6.f;
CGFloat const kFuncLineSpacing        = 20.f;
CGFloat const kFuncItemSpacing        = 20.f;
CGFloat const kFuncHorizontalPadding  = 20;
CGFloat const kFuncVerticalPadding    = 5.f;


@implementation GYFuncManagementLayout

- (void)prepareLayout
{
    [super prepareLayout];

    CGFloat featureItemW         = 0;
    CGFloat featureItemH         = 0;
    CGFloat collectionViewH      = 0;
    if (IS_IPAD) {
        featureItemW             = (SCREEN_WIDTH - 2 * kFuncHorizontalPadding - 5 * kFuncItemSpacing) / kFuncIPadRowItemCount;
        featureItemH             = (featureItemW * kFuncManagementItemH) / kFuncManagementItemW;
        collectionViewH          = featureItemH + kFuncVerticalPadding * 2;
    }
    else {
        featureItemW             = (SCREEN_WIDTH - 2 * kFuncHorizontalPadding - 2 * kFuncItemSpacing) / kFuncIPhoneRowItemCount;
        featureItemH             = (featureItemW * kFuncManagementItemH) / kFuncManagementItemW;
        collectionViewH          = featureItemH * 2 + kFuncVerticalPadding * 2 + kFuncLineSpacing;
    }

    self.itemSize                = CGSizeMake(featureItemW, featureItemH);
    self.minimumLineSpacing      = kFuncLineSpacing;
    self.minimumInteritemSpacing = kFuncItemSpacing;
    self.scrollDirection         = UICollectionViewScrollDirectionVertical;
    self.sectionInset            = UIEdgeInsetsMake(kFuncVerticalPadding, kFuncHorizontalPadding, kFuncVerticalPadding, kFuncHorizontalPadding);
    self.collectionView.bounces  = NO;
//    self.headerReferenceSize     = CGSizeMake(SCREEN_WIDTH, 45);
    self.collectionView.showsVerticalScrollIndicator   = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
}


@end
