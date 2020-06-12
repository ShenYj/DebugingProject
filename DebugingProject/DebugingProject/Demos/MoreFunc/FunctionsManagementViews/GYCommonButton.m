//
//  GYCommonButton.m
//  GyyxApp
//
//  Created by Shen on 2019/12/5.
//  Copyright © 2019 gyyx. All rights reserved.
//

#import "GYCommonButton.h"

@implementation GYCommonButton

- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self initGYButton];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initGYButton];
}

- (instancetype)initGYButton
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_com_bg_enabled"] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_com_bg_disabled"] forState:UIControlStateDisabled];
        [self setBackgroundImage:[UIImage imageNamed:@"btn_com_bg_disabled"] forState:UIControlStateHighlighted];
    }
    return self;
}

- (instancetype)initWithBGColor:(UIColor *)bgColour frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        if (@available(iOS 11.0, *)) {
            self.layer.cornerRadius  = 5;
            self.layer.maskedCorners = kCALayerMaxXMaxYCorner | kCALayerMinXMinYCorner;
        } else {
            // Fallback on earlier versions
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect: self.bounds
                                                           byRoundingCorners: UIRectCornerTopLeft | UIRectCornerBottomRight
                                                                 cornerRadii: CGSizeMake(5, 5)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            self.layer.mask = maskLayer;
        }
        [self setTitleColor:COMMON_SCHEME_WHITE_COLOR forState:UIControlStateNormal];
        [self setTitleColor:COMMON_SCHEME_GRAY_COLOR forState:UIControlStateHighlighted];
        [self setTitleColor:COMMON_SCHEME_GRAY_COLOR forState:UIControlStateSelected];
        [self setTitleColor:COMMON_SCHEME_GRAY_COLOR forState:UIControlStateDisabled];
        [self setBackgroundColor:bgColour];
    }
    return self;
}

- (instancetype)initWithBorderColor:(UIColor *)borderColour frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self setTitleColor:COMMON_SCHEME_GRAY_COLOR forState:UIControlStateHighlighted];
        [self setTitleColor:COMMON_SCHEME_GRAY_COLOR forState:UIControlStateSelected];
        [self setTitleColor:COMMON_SCHEME_GRAY_COLOR forState:UIControlStateDisabled];
        self.layer.borderColor = borderColour.CGColor;
        self.layer.borderWidth = 1;
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

@end
