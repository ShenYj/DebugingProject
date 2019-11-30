//
//  SYJTransitioningViewController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/11/24.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJTransitioningViewController.h"
#import "SYJModalViewController.h"
#import "SYJBouncePresentAnimation.h"

@interface SYJTransitioningViewController () <ModalViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) SYJBouncePresentAnimation *presentAnimation;

@end

@implementation SYJTransitioningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    _presentAnimation = [SYJBouncePresentAnimation new];
}
- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"转场" style:UIBarButtonItemStylePlain target:self action:@selector(buttonClicked:)];
}

- (void)buttonClicked:(id)sender
{
    SYJModalViewController *mvc =  [[SYJModalViewController alloc] init];
    mvc.delegate = self;
    mvc.transitioningDelegate = self;
    [self presentViewController:mvc animated:YES completion:nil];
}

#pragma mark - ModalViewControllerDelegate

- (void)modalViewControllerDidClickedDismissButton:(SYJModalViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    return self.presentAnimation;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
