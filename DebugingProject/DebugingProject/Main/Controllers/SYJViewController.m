//
//  SYJViewController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/11/23.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJViewController.h"
#import "SYJBaseModel.h"
#import <YYModel.h>


static NSString * const kTableViewReusedID = @"kTableViewReusedID";
@interface SYJViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray <SYJBaseModel *> *sources;

@end

@implementation SYJViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kTableViewReusedID];
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
        make.top.mas_equalTo(self.view).mas_offset(NAVIGATION_STATUS_HEIGHT);
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.sources.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewReusedID forIndexPath:indexPath];
    cell.textLabel.text = self.sources[indexPath.row].title;
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *clsName = self.sources[indexPath.row].clsName;
    Class cls = NSClassFromString(clsName);
    id vc = [cls new];
    if ([vc isKindOfClass:[UIViewController class]]) {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray<SYJBaseModel *> *)sources {
    if (!_sources) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"DemoList.plist" ofType:nil];
        NSArray *files = [NSArray arrayWithContentsOfFile:filePath];
        NSMutableArray <SYJBaseModel *>*temp = [NSMutableArray array];
        [files enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [temp addObject:[SYJBaseModel yy_modelWithJSON:obj]];
        }];
        _sources = temp.copy;
    }
    return _sources;
}

@end
