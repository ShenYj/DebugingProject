//
//  SYJCollectionsController.m
//  DebugingProject
//
//  Created by ShenYj on 2019/12/4.
//  Copyright © 2019 ShenYj. All rights reserved.
//

#import "SYJCollectionsController.h"
#import "SYJCollectionHeaderView.h"
#import "SYJCollectionsLayout.h"
#import "SYJCollectionViewCell.h"

static NSString * const kCollectionReusedID = @"kCollectionReusedID";
static NSString * const kCollectionHeaderReusedID = @"kCollectionHeaderReusedID";
@interface SYJCollectionsController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collections;

@property (nonatomic, strong) NSArray <NSArray *>*dataSources;

@property (nonatomic, assign) BOOL editing;

@end

@implementation SYJCollectionsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupView];
}

- (void)setupView
{
    if (@available(iOS 11.0, *)) {
        self.collections.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStyleDone target:self action:@selector(reloadCollectionView:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collections registerClass:[SYJCollectionViewCell class] forCellWithReuseIdentifier:kCollectionReusedID];
    [self.collections registerClass:[SYJCollectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionHeaderReusedID];
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    [self.collections addGestureRecognizer:longPressGesture];
    
    [self.view addSubview:self.collections];
    [self.collections mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).mas_offset(NAVIGATION_STATUS_HEIGHT);
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(0);
    }];
}

- (void)reloadCollectionView:(UIBarButtonItem *)sender
{
    self.editing = !self.editing;
    [self.collections reloadData];
}

#pragma mark - target

- (void)longPressGesture:(UILongPressGestureRecognizer *)gesture
{
    CGPoint position = [gesture locationInView:self.collections];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            NSIndexPath *indexPath = [self.collections indexPathForItemAtPoint:position];
            if (@available(iOS 9.0, *)) {
                [self.collections beginInteractiveMovementForItemAtIndexPath:indexPath];
            } else {
                // Fallback on earlier versions
            }
        }
            break;
        case  UIGestureRecognizerStateChanged:
        {
            if (@available(iOS 9.0, *)) {
                [self.collections updateInteractiveMovementTargetPosition:position];
            } else {
                // Fallback on earlier versions
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            if (@available(iOS 9.0, *)) {
                [self.collections endInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
        }
            break;
        default:
        {
            if (@available(iOS 9.0, *)) {
                [self.collections cancelInteractiveMovement];
            } else {
                // Fallback on earlier versions
            }
        }
            break;
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.dataSources.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *items = self.dataSources[section];
    return items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SYJCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionReusedID forIndexPath:indexPath];
    cell.label.text = self.dataSources[indexPath.section][indexPath.row];
    cell.isEditing = self.editing;
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *supplementaryView;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
        SYJCollectionHeaderView *view = (SYJCollectionHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kCollectionHeaderReusedID forIndexPath:indexPath];
        view.label.text = [NSString stringWithFormat:@" section: %ld item: %ld", (long)indexPath.section, (long)indexPath.item];
        supplementaryView = view;
        
    }
    return supplementaryView;
}


- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath API_AVAILABLE(ios(9.0))
{
    return YES;
}
- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath API_AVAILABLE(ios(9.0))
{
    NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:self.dataSources[sourceIndexPath.section]];
    NSMutableArray *destinArray = [NSMutableArray arrayWithArray:self.dataSources[destinationIndexPath.section]];
    
    NSString *toDesItem = sourceArray[sourceIndexPath.item];
    NSString *toSouItem = nil;
    
    // 1. 同组数据编辑顺序
    if (sourceIndexPath.section == destinationIndexPath.section) {
        toSouItem = destinArray[destinationIndexPath.item];
        
        sourceArray[destinationIndexPath.item] = toDesItem;
        sourceArray[sourceIndexPath.item]      = toSouItem;
        
        if (sourceIndexPath.section == 0) {
            self.dataSources = @[sourceArray.copy, self.dataSources[1]];
        }
        else {
            self.dataSources = @[self.dataSources[1], sourceArray.copy];
        }
        [self.collections reloadSections:[NSIndexSet indexSetWithIndex:sourceIndexPath.section]];
        return;
    }
    // 2 不同组编辑顺序, 注:可能越界
    // 2.1 不同section编辑, section 0 -> section 1 不允许
    if (destinationIndexPath.section == 1) {
        NSLog(@" 0->1 不允许 [%zd-->%zd]", sourceIndexPath.item , destinationIndexPath.item);
        [self.collections reloadData];
        return;
    }
    // 2.2 不同section编辑, section 1 -> section 0 允许
    NSLog(@"目标位置: %zd", destinationIndexPath.item);
    // 插入最后一个不存在的位置:越界处理
    if (destinationIndexPath.item > destinArray.count - 1 ) {
        if (destinArray.count >= 8) {
            // 2.2.1  section 满8个 不可插入
            NSLog(@"插入最后一个不存在的位置, 满8个不可插入");
        }
        else {
            // 2.2.2  section 不满8个 可插入
            [destinArray addObject:toDesItem];
            [sourceArray removeObjectAtIndex:sourceIndexPath.item];
            self.dataSources = @[destinArray.copy, sourceArray];
            NSLog(@"插入最后一个不存在的位置, 不满8个, 插到目标集合最后位置, 并移除源的最后一个");
        }
        [self.collections reloadData];
        return;
    }
    else {
        toSouItem = destinArray[destinationIndexPath.item];
    }
    // 2.3. 不同section编辑, section 1 -插入-> section 0
    NSLog(@"不同组交换, 1 -> 0");
    [destinArray insertObject:toDesItem atIndex:destinationIndexPath.item];
    [sourceArray removeObjectAtIndex:sourceIndexPath.item];
    if (destinArray.count > 8) {
        // 满8 交换
        toSouItem = destinArray.lastObject;
        [sourceArray addObject:toSouItem];
        [destinArray removeLastObject];
    }

    self.dataSources = @[destinArray.copy, sourceArray.copy];
    [self.collections reloadData];
}

#pragma mark - UICollectionViewDelegate


#pragma mark - lazy

- (UICollectionView *)collections {
    if (!_collections) {
        _collections = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[SYJCollectionsLayout alloc] init]];
        _collections.backgroundColor = [UIColor whiteColor];
        _collections.dataSource = self;
        _collections.delegate   = self;
    }
    return _collections;
}

- (NSArray<NSArray *> *)dataSources {
    if (!_dataSources) {
        _dataSources =
        @[
            @[
                @"51",
                @"52",
                @"53",
                @"54",
                //                @"55",
                //                @"56",
                //                @"57",
                //                @"58",
            ],
            @[
                @"01",
                @"02",
                @"03",
                @"04",
                @"05",
                @"06",
                @"07",
                @"08",
                @"09",
                @"10",
                @"11",
                @"12",
                @"13",
                @"14",
                @"15",
                @"16",
                @"17",
                @"18",
                @"19",
                @"20",
                @"21",
                @"22",
                @"23",
                @"24",
                @"25",
                @"26",
                @"27",
                @"28",
                @"29",
                @"30",
            ]
        ];
    }
    return _dataSources;
}

@end
