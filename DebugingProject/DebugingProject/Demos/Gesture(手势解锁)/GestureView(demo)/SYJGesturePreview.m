//
//  SYJGesturePreview.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/1.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJGesturePreview.h"
#import "SYJGestureItemView.h"
#import "SYJGestureConst.h"

@implementation SYJGesturePreview

- (instancetype)init
{
    if (self = [super init]) {
        // 解锁视图准备
        [self lockViewPrepare];
    }
    return self;
}

/*
 *  解锁视图准备
 */
- (void)lockViewPrepare
{
    self.backgroundColor = [UIColor clearColor];
    for (int i = 0; i < 9; i++) {
        SYJGestureItemView *circle = [[SYJGestureItemView alloc] init];
        circle.type = CircleTypeInfo;
        [self addSubview:circle];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat itemViewWH = CircleInfoRadius * 2;
    CGFloat marginValue = (self.frame.size.width - 3 * itemViewWH) / 3.0f;
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        NSUInteger row = idx % 3;
        NSUInteger col = idx / 3;
        CGFloat x = marginValue * row + row * itemViewWH + marginValue/2;
        CGFloat y = marginValue * col + col * itemViewWH + marginValue/2;
        CGRect frame = CGRectMake(x, y, itemViewWH, itemViewWH);
        // 设置tag -> 密码记录的单元
        subview.tag = idx + 1;
        subview.frame = frame;
    }];
}

@end
