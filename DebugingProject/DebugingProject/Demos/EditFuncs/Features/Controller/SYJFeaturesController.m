//
//  SYJFeaturesController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/15.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJFeaturesController.h"
#import "SYJFeatureManagerCell.h"
#import "SYJFeatureManagerLayout.h"
#import "SYJFeatureManagerHeaderView.h"
#import "SYJFeatureManagerFooterView.h"


static NSString * const kFeatureManagerCellReusedID = @"kFeatureManagerCellReusedID";
static NSString * const kFeatureManagerHeaderReusedID = @"kFeatureManagerHeaderReusedID";
static NSString * const kFeatureManagerFooterReusedID = @"kFeatureManagerFooterReusedID";
@interface SYJFeaturesController () <SYJFeatureManagerDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) SYJFeatureManagerLayout *layout;
@property (nonatomic, strong) UICollectionView *featureManagerCollectionView;

@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, assign) BOOL inEditState;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *groupArray;

@end

@implementation SYJFeaturesController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupFeatures];
}

- (void)setupData
{
    for (int i = 0; i < 6; i++) {
        SYJFeatureManagerModel *model = [[SYJFeatureManagerModel alloc] init];
        model.title = [NSString stringWithFormat:@"推荐%@", @(i)];
        [self.dataArray addObject:model];
        [self.groupArray addObject:model];
    }
    for (int i = 0; i < 4; i++) {
        SYJFeatureManagerModel *model = [[SYJFeatureManagerModel alloc] init];
        model.title = [NSString stringWithFormat:@"生活%@", @(i)];
        [self.groupArray addObject:model];
    }
}

- (void)setupFeatures
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"功能管理";
    self.rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightBtn setTitle:@"管理" forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(rightBarButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [_rightBtn sizeToFit];
    [_rightBtn setTitle:@"完成" forState:UIControlStateSelected];
    [_rightBtn setTitle:@"管理" forState:UIControlStateNormal];    [_rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    //将leftItem设置为自定义按钮
    UIBarButtonItem *rightItem =[[UIBarButtonItem alloc] initWithCustomView: _rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    
    [self.view addSubview:self.featureManagerCollectionView];
    [self.featureManagerCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(NAVIGATION_STATUS_HEIGHT);
    }];
}

#pragma mark - target

- (void)rightBarButtonItemAction:(UIBarButtonItem *)sender
{
    if (!self.inEditState) { //点击了管理
        self.inEditState = YES;
        self.featureManagerCollectionView.allowsSelection = NO;
    } else { //点击了完成
        self.inEditState = NO;
        self.featureManagerCollectionView.allowsSelection = YES;
        //此处可以调用网络请求，把排序完之后的传给服务端
        NSLog(@"点击了完成按钮");
    }
    [self.layout setInEditState:self.inEditState];
}

#pragma mark - SYJFeatureManagerDelegate

///  更新数据源
- (void)moveItemAtIndexPath:(NSIndexPath *)formPath toIndexPath:(NSIndexPath *)toPath
{
    SYJFeatureManagerModel *model = self.dataArray[formPath.row];
    // 先把移动的这个model移除
    [self.dataArray removeObject:model];
    // 再把这个移动的model插入到相应的位置
    [self.dataArray insertObject:model atIndex:toPath.row];
}
/// 改变编辑状态
- (void)didChangeEditState:(BOOL)inEditState
{
    self.inEditState = inEditState;
    self.rightBtn.selected = inEditState;
    for (SYJFeatureManagerCell *cell in self.featureManagerCollectionView.visibleCells) {
        cell.inEditState = inEditState;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.dataArray.count;
    } else {
        return self.groupArray.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYJFeatureManagerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFeatureManagerCellReusedID forIndexPath:indexPath];
    [cell setDataAry:self.dataArray groupAry:self.groupArray indexPath:indexPath];
    //是否处于编辑状态，如果处于编辑状态，出现边框和按钮，否则隐藏
    cell.inEditState = self.inEditState;
    //    [cell.button addTarget:self action:@selector(btnClick:event:) forControlEvents:UIControlEventTouchUpInside];
    
    __weak typeof(self) weakSelf = self;
    [cell setEditTargetBlock:^(UIButton * _Nonnull sender, UIEvent * _Nonnull event) {
        NSSet *touches = [event allTouches];
        UITouch *touch = [touches anyObject];
        CGPoint currentPoint = [touch locationInView:weakSelf.featureManagerCollectionView];
        NSIndexPath *indexPath = [weakSelf.featureManagerCollectionView indexPathForItemAtPoint:currentPoint];
        if (indexPath.section == 0 && indexPath != nil) { //点击移除
            [weakSelf.featureManagerCollectionView performBatchUpdates:^{
                [weakSelf.featureManagerCollectionView deleteItemsAtIndexPaths:@[indexPath]];
                [self.dataArray removeObjectAtIndex:indexPath.row]; //删除
            } completion:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.featureManagerCollectionView reloadData];
                });
            }];
        } else if (indexPath != nil) { //点击添加
            //在第一组最后增加一个
            [self.dataArray addObject:self.groupArray[indexPath.row]];
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:self.dataArray.count - 1 inSection:0];
            [weakSelf.featureManagerCollectionView performBatchUpdates:^{
                [weakSelf.featureManagerCollectionView insertItemsAtIndexPaths:@[newIndexPath]];
            } completion:^(BOOL finished) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [weakSelf.featureManagerCollectionView reloadData];
                });
            }];
        }
    }];
    return cell;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        SYJFeatureManagerHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFeatureManagerHeaderReusedID forIndexPath:indexPath];
        if (indexPath.section == 0) {
            headView.headLabel.text = @"我的应用";
        } else {
            headView.headLabel.text = @"便捷生活";
        }
        return headView;
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        SYJFeatureManagerFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFeatureManagerFooterReusedID forIndexPath:indexPath];
        return footView;
    }
    return nil;
}

#pragma mark - lazy

- (SYJFeatureManagerLayout *)layout {
    if (!_layout) {
        _layout = [[SYJFeatureManagerLayout alloc] init];
        CGFloat width = (SCREEN_WIDTH - 80) / 4;
        _layout.itemSize = CGSizeMake(width, width);
        // 设置滚动方向的间距
        _layout.minimumLineSpacing = 10;
        // 设置上方的反方向
        _layout.minimumInteritemSpacing = 0;
        // 设置collectionView整体的上下左右之间的间距
        _layout.sectionInset = UIEdgeInsetsMake(15, 20, 20, 20);
        // 设置滚动方向
        _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _layout.delegate = self;
    }
    return _layout;
}

- (UICollectionView *)featureManagerCollectionView {
    if (!_featureManagerCollectionView) {
        _featureManagerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.layout];
        _featureManagerCollectionView.backgroundColor = [UIColor whiteColor];
        _featureManagerCollectionView.dataSource = self;
        [_featureManagerCollectionView registerClass:[SYJFeatureManagerCell class] forCellWithReuseIdentifier:kFeatureManagerCellReusedID];
        [_featureManagerCollectionView registerClass:[SYJFeatureManagerHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFeatureManagerHeaderReusedID];
        //注册一个区尾视图
        [_featureManagerCollectionView registerClass:[SYJFeatureManagerFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFeatureManagerFooterReusedID];
    }
    return _featureManagerCollectionView;
}
- (NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _dataArray;
}

- (NSMutableArray *)groupArray
{
    if (_groupArray == nil) {
        _groupArray = [NSMutableArray arrayWithCapacity:1];
    }
    return _groupArray;
}
@end
