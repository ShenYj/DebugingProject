//
//  SYJPageController.m
//  DebugingProject
//
//  Created by ShenYj on 2020/3/21.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "SYJPageController.h"

@interface SYJPageController ()

@property (nonatomic, strong) NSArray <UIViewController *> *childPageControllers;

@end

@implementation SYJPageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupPageControllerView];
}

- (void)setupPageControllerView
{
    self.view.backgroundColor = [UIColor orangeColor];
}

#pragma mark - Data source

- (NSArray<UIViewController *> *)childPageControllers {
    if (!_childPageControllers) {
        if ([self.dataSource respondsToSelector:@selector(childrenControllersForPageController:)]) {
            _childPageControllers = [self.dataSource childrenControllersForPageController:self];
        }
        else {
            _childPageControllers = @[];
        }
    }
    return _childPageControllers;
}

@end
