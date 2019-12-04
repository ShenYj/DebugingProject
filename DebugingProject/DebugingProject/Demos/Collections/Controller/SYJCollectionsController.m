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

static NSString * const kCollectionReusedID = @"kCollectionReusedID";
static NSString * const kCollectionHeaderReusedID = @"kCollectionHeaderReusedID";
@interface SYJCollectionsController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collections;

@property (nonatomic, strong) NSArray <NSArray *>*dataSources;

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
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.collections registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCollectionReusedID];
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
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionReusedID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 256 / 255.0
                                           green:arc4random() % 256 / 255.0
                                            blue:arc4random() % 256 / 255.0
                                           alpha:1.0];
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

    NSString *sourceItem = self.dataSources[sourceIndexPath.section][sourceIndexPath.item];
    NSMutableArray *sourceArray = [NSMutableArray arrayWithArray:self.dataSources[sourceIndexPath.section]];
    NSMutableArray *destinationArray = [NSMutableArray arrayWithArray:self.dataSources[destinationIndexPath.section]];
    [sourceArray removeObjectAtIndex:sourceIndexPath.item];
    [destinationArray insertObject:sourceItem atIndex:destinationIndexPath.item];
    
    
    NSString *lastItem = destinationArray.lastObject;
    [sourceArray addObject:lastItem];
    
    self.dataSources = @[destinationArray.copy, sourceArray.copy];
}

#pragma mark - UICollectionViewDelegate


#pragma mark - lazy

- (UICollectionView *)collections {
    if (!_collections) {
        _collections = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[[SYJCollectionsLayout alloc] init]];
        _collections.backgroundColor = [UIColor whiteColor];
        _collections.dataSource = self;
        
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
                @"55",
                @"56",
                @"57",
                @"58",
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
