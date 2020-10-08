//
//  SYJCollectionsLayout.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/4.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJCollectionsLayout.h"

CGFloat const kRowItemCount = 4;
@implementation SYJCollectionsLayout

- (void)prepareLayout
{
    [super prepareLayout];
    CGFloat itemW = [UIScreen mainScreen].bounds.size.width / kRowItemCount;
    self.itemSize                = CGSizeMake(itemW, itemW);
    self.minimumLineSpacing      = 0;
    self.minimumInteritemSpacing = 0;
    self.scrollDirection         = UICollectionViewScrollDirectionVertical;
    self.collectionView.bounces  = NO;
    self.collectionView.showsVerticalScrollIndicator   = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 60);
    if (@available(iOS 9.0, *)) {
//        self.sectionHeadersPinToVisibleBounds = YES;
    } else {
        // Fallback on earlier versions
    }
    self.footerReferenceSize = CGSizeMake(SCREEN_WIDTH, 0);
}

@end
