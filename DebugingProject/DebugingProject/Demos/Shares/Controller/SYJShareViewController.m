//
//  SYJShareViewController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/8.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJShareViewController.h"
#import "LWShareService.h"

@interface SYJShareViewController ()

@property (nonatomic, strong) UIButton *shareButton;

@end

@implementation SYJShareViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupShareView];
}

- (void)setupShareView
{
    self.view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:self.shareButton];
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(100, 44));
    }];
}

#pragma mark target

- (void)targetShareButton:(UIButton *)sender
{
    [LWShareService shared].shareBtnClickBlock = ^(NSIndexPath *index) {
        NSLog(@"%@ (%s)", index, __func__);
    };
    [LWShareService shared].shareBtnCancelBlock = ^(){
        NSLog(@"取消");
    };
    [[LWShareService shared] showInViewController:self];
}

#pragma mark - lazy

- (UIButton *)shareButton {
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton setTitle:@"" forState:UIControlStateHighlighted];
        [_shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _shareButton.layer.borderColor = [UIColor grayColor].CGColor;
        _shareButton.layer.borderWidth = 1;
        _shareButton.layer.cornerRadius = 5;
        _shareButton.layer.masksToBounds = YES;
        [_shareButton addTarget:self action:@selector(targetShareButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareButton;
}

@end
