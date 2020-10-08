//
//  SYJFuncDemoController.m
//  DebugingProject
//
//  Created by ShenYj on 2020/10/8.
//  Copyright © 2020 ShenYj. All rights reserved.
//

#import "SYJFuncDemoController.h"

static NSString * const kMoreFuncDemosTableViewCellReusedID = @"kMoreFuncDemosTableViewCellReusedID";
@interface SYJFuncDemoController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray <NSDictionary *> *demos;
@property (nonatomic, strong) UITableView *demosTableView;

@end

@implementation SYJFuncDemoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多页demo";
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.demosTableView];
    CGFloat topMargin = [[UIApplication sharedApplication] statusBarFrame].size.height + self.navigationController.navigationBar.frame.size.height;
    [self.demosTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(topMargin);
    }];
}

#pragma mark - UITableViewDataSources

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.demos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kMoreFuncDemosTableViewCellReusedID forIndexPath:indexPath];
    cell.textLabel.text = self.demos[indexPath.row][@"title"];
    return cell;
}
#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *clsName = self.demos[indexPath.row][@"cls"];
    Class class = NSClassFromString(clsName);
    [self.navigationController pushViewController:[class new] animated:YES];
}

#pragma mark - lazy

- (UITableView *)demosTableView {
    if (!_demosTableView) {
        _demosTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _demosTableView.dataSource = self;
        _demosTableView.delegate  = self;
        [_demosTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kMoreFuncDemosTableViewCellReusedID];
    }
    return _demosTableView;
}

- (NSArray<NSDictionary *> *)demos {
    if (!_demos) {
        _demos = @[
            @{
                @"title": @"可编辑的CollectionView Demo(9.0)",
                @"cls": @"SYJCollectionsController"
            },
            @{
                @"title": @"仿支付宝小程序编辑页",
                @"cls": @"SYJFeaturesController"
            },
            @{
                @"title": @"仿支付宝更多页面(TBD)",
                @"cls": @"SYJFunctionsManagementController"
            },
        ];
    }
    return _demos;
}

@end
