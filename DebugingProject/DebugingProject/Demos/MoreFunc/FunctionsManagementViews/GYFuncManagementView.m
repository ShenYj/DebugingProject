//
//  GYFuncManagementView.m
//  GyyxApp
//
//  Created by Shen on 2020/3/17.
//  Copyright © 2020 gyyx. All rights reserved.
//

#import "GYFuncManagementView.h"
#import "GYFuncConfigModel.h"
#import "GYFunctionManager.h"
#import "GYTBDFunctionCell.h"
#import "GYFuncManagementAddCell.h"
#import "GYFuncManagementRemoveCell.h"
#import "GYFuncManagementLayout.h"
#import "GYFuncManagementNormalSectionHeaderView.h"
#import "GYFuncManagementNormalSectionFooterView.h"
#import "GYFuncManagementLastSectionFooterView.h"

// 已选Section的最多item个数
static NSInteger const kSelectedFuncMaxCount = 5;

// 已选择样式Cell的可重用标识
static NSString * const kSelectedFunctionCellReusedID                  = @"kSelectedFunctionCellReusedID";
// 待设置样式Cell的可重用标识
static NSString * const kTBDFunctionCellReusedID                       = @"kTBDFunctionCellReusedID";

// 可选区域样式Cell的可重用标识
static NSString * const kFuncManagementOptionalCellReusedID            = @"kFuncManagementOptionalCellReusedID";

// 普通样式的section header 带有一个左侧对齐的Label
static NSString * const kFuncManagementNormalSectionHeaderReusedID     = @"kFuncManagementNormalSectionHeaderReusedID";
// 普通样式Section footer 5pt的高度间距
static NSString * const kFuncManagementNormalSectionFooterReusedID     = @"kFuncManagementNormalSectionFooterReusedID";
// 最后一个Section footer - 到底啦 -
static NSString * const kFuncManagementNoMoreSectionFooterReusedID     = @"kFuncManagementNoMoreSectionFooterReusedID";


@interface GYFuncManagementView () <UICollectionViewDataSource, UICollectionViewDelegate>

// 原始数据
@property (nonatomic, strong) GYFuncConfigModel *originalFuncConfigModel;
// 展示数据
@property (nonatomic, strong) GYFuncConfigModel *disPlayFuncConfigModel;
// 已选功能集合
@property (nonatomic, strong) NSMutableArray <GYFunctionModel *> *selectedFuncModelArray;

#pragma mark - UI
@property (nonatomic, strong) UILabel                *headTitleLabel;
@property (nonatomic, strong) UICollectionView       *fmDisplayedFuncsCollectionView;
@property (nonatomic, strong) UIView                 *seperatorView;
@property (nonatomic, strong) UILabel                *moreFuncsLabel;
@property (nonatomic, strong) UIView                 *selectedFuncsView;
@property (nonatomic, strong) UIView                 *snapshotFuncItem;
@property (nonatomic, strong) NSIndexPath            *currentIndexPath;
@property (nonatomic, strong) NSIndexPath            *sourceIndexPath;

@property (nonatomic, strong) UICollectionView       *fmOptionalCollectonView;

@end

@implementation GYFuncManagementView

#pragma mark

#pragma mark - UI

- (instancetype)initWithFrame:(CGRect)frame
{
    return [self initWithFrame:SCREEN_BOUNDS funcConfigModel:nil editState:NO];
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    return [self initWithFrame:SCREEN_BOUNDS funcConfigModel:nil editState:NO];
}
- (instancetype)initWithFrame:(CGRect)frame funcConfigModel:(nullable GYFuncConfigModel *)funcConfigModel editState:(BOOL)editState
{
    self = [super initWithFrame:frame];
    if (self) {
        _editState = editState;
        _originalFuncConfigModel = funcConfigModel;
        [self setupFuncManagementView];
        [self initData];
    }
    return self;
}
- (void)setupFuncManagementView
{
    self.backgroundColor = WHITE_COLOR;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    if (@available(iOS 13.0, *)) {
        self.automaticallyAdjustsScrollIndicatorInsets = NO;
    }
    self.bounces = NO;
    
    [self addSubview:self.selectedFuncsView];
    [self addSubview:self.fmOptionalCollectonView];
    
    [self reloadFuncsView];
}
- (void)reloadFuncsView
{
    [self.fmDisplayedFuncsCollectionView reloadData];
    [self.fmOptionalCollectonView reloadData];
    
    [self programUpdateViewSize];
}
- (void)programUpdateViewSize
{
//    [self.fmOptionalCollectonView reloadData];
    [self.fmOptionalCollectonView layoutIfNeeded];
    CGSize funcManagementViewSize = self.fmOptionalCollectonView.contentSize;
    CGFloat funcManagementViewMinH = MAX((self.height - self.selectedFuncsView.height), funcManagementViewSize.height);
    self.fmOptionalCollectonView.frame = CGRectMake(0, self.selectedFuncsView.height, SCREEN_WIDTH, funcManagementViewMinH);
    self.contentSize = CGSizeMake(SCREEN_WIDTH, self.selectedFuncsView.height + funcManagementViewMinH);
}

#pragma mark

#pragma mark - Data Operate

- (void)initData
{
    [GYPureProgressHUD show];

    GYFuncConfigModel *mutableCopyConfigModel = [[GYFunctionManager shareManager] publicGetMutableCopyFunConfigModel:self.originalFuncConfigModel];
    // 已选功能 ID
    NSMutableArray <NSNumber *> *selectedIDs = [NSMutableArray arrayWithArray:mutableCopyConfigModel.selectedFuncIDs.mutableCopy];
    // 当前已选择的功能集合
//    self.selectedFuncModelArray = [NSMutableArray arrayWithArray:[self publicGetAllSelectedFuncsWithFuncIDs:selectedIDs]];
    self.selectedFuncModelArray = [self publicGetAllSelectedFuncsWithFuncIDs:selectedIDs];
    // 可选功能组数据
    mutableCopyConfigModel.groupData = [self publicGetOptionFuncsWithSelectedFuncIDs:selectedIDs];
    self.disPlayFuncConfigModel = mutableCopyConfigModel;
    
    [GYPureProgressHUD dismiss];
}

/// 根据当前已选择的功能ID集合, 筛选出当前未被选择的全部功能组数据
- (NSMutableArray <GYFunctionGroupModel *> *)publicGetOptionFuncsWithSelectedFuncIDs:(NSArray <NSNumber *> *)selectedFuncIDs
{
    GYFuncConfigModel *originalConfigModel = [[GYFunctionManager shareManager] publicGetMutableCopyFunConfigModel:self.originalFuncConfigModel];
    NSMutableArray <GYFunctionGroupModel *> *funcGroupsArr = [NSMutableArray arrayWithArray:originalConfigModel.groupData.mutableCopy];
    
    if (!selectedFuncIDs || ![selectedFuncIDs isKindOfClass:[NSArray class]] || selectedFuncIDs.count < 1) {
        
    }
    NSMutableArray <NSArray <GYFunctionModel *> *> *optionalFuncsArr = [NSMutableArray array];
    NSString *kFunctionID                  = NSStringFromSelector(@selector(functionID));
    [funcGroupsArr enumerateObjectsUsingBlock:^(GYFunctionGroupModel * _Nonnull groupModel, NSUInteger idx, BOOL * _Nonnull stop) {
        NSArray <GYFunctionModel *>*newFuncData = [groupModel.funcData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"NOT(SELF.%K IN %@)", kFunctionID, selectedFuncIDs]];
        [optionalFuncsArr addObject:newFuncData];
    }];

    [funcGroupsArr enumerateObjectsUsingBlock:^(GYFunctionGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.funcData = optionalFuncsArr[idx];
    }];
    return funcGroupsArr;
}
/// 获取全部功能的集合, 一位数组
- (NSMutableArray <GYFunctionModel *> *)publicGetAllFuncs
{
    GYFuncConfigModel *mutableCopyConfigModel = [[GYFunctionManager shareManager] publicGetMutableCopyFunConfigModel:self.originalFuncConfigModel];
    NSMutableArray <GYFunctionGroupModel *> *funcGroupsArr = [NSMutableArray arrayWithArray:mutableCopyConfigModel.groupData.mutableCopy];
    NSMutableArray <GYFunctionModel *> *allFuncModelsArr = [NSMutableArray array];
    [funcGroupsArr enumerateObjectsUsingBlock:^(GYFunctionGroupModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj.funcData enumerateObjectsUsingBlock:^(GYFunctionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [allFuncModelsArr addObject:obj];
        }];
    }];
    return allFuncModelsArr;
}
/// 获取全部已选功能的集合, 一维数组
- (NSMutableArray <GYFunctionModel *> *)publicGetAllSelectedFuncsWithFuncIDs:(NSArray <NSNumber *> *)selectedFuncIDs
{
    NSString *kFunctionID = NSStringFromSelector(@selector(functionID));
    NSMutableArray <GYFunctionModel *> *allFuncModelsArr = [self publicGetAllFuncs];
    NSPredicate *selectedPredicate = [NSPredicate predicateWithFormat:@"SELF.%K IN %@", kFunctionID, selectedFuncIDs];
    NSArray <GYFunctionModel *> *selectedModels = [allFuncModelsArr filteredArrayUsingPredicate:selectedPredicate];
    
    // 排序
    NSMutableArray <GYFunctionModel *> *sortSelFuncsArr = [NSMutableArray arrayWithCapacity:selectedModels.count];
    [selectedFuncIDs enumerateObjectsUsingBlock:^(NSNumber * _Nonnull funcID, NSUInteger idx, BOOL * _Nonnull stop) {
        [selectedModels enumerateObjectsUsingBlock:^(GYFunctionModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.functionID.intValue == funcID.intValue) {
                [sortSelFuncsArr addObject:obj];
            }
        }];
    }];
    return sortSelFuncsArr.mutableCopy;
}

/// 检查快接入口列表的功能是否发生变更
- (BOOL)publickCheckQuickFuncsChanged
{
    BOOL isChanged = NO;
    
    NSArray <NSNumber *> *disFuncIDs = self.disPlayFuncConfigModel.selectedFuncIDs;
    NSArray <NSNumber *> *oriFuncIDs = self.originalFuncConfigModel.selectedFuncIDs;
    
    GYDebugLog(@"展示功能: %@", [disFuncIDs componentsJoinedByString:@","]);
    GYDebugLog(@"原始功能: %@", [oriFuncIDs componentsJoinedByString:@","]);
    if (disFuncIDs.count != oriFuncIDs.count) {
        isChanged = YES;
        return isChanged;
    }
    
    for (int i = 0; i < disFuncIDs.count; i ++) {
        if (disFuncIDs[i].intValue != oriFuncIDs[i].intValue) {
            isChanged = YES;
            break;
        }
    }
    return isChanged;
}


///// 获取全部未选的功能集合, 一维数组 TBD , 暂时无用
//- (NSArray <GYFunctionModel *> *)publicGetAllOptionalFuncsWithFuncIDs:(NSArray <NSNumber *> *)selectedFuncIDs
//{
//    NSString *kFunctionID = NSStringFromSelector(@selector(functionID));
//    NSMutableArray <GYFunctionModel *> *allFuncModelsArr = [self publicGetAllFuncs];
//    // 未添加的功能集合
//    NSPredicate *optionalPredicate = [NSPredicate predicateWithFormat:@"NOT(SELF.%K IN %@)", kFunctionID, selectedFuncIDs];
//    return [allFuncModelsArr filteredArrayUsingPredicate:optionalPredicate];
//}

#pragma mark

#pragma mark - inSide target

// 从已选中删除元素
- (void)removeFunc:(GYFunctionModel *)funcModel disIndexPath:(NSIndexPath *)disIndexPath
{
    GYWarnLog(@"从已选区域删除第[%zd]个功能: %@", disIndexPath.item + 1, funcModel.functionName);
    NSMutableArray <NSNumber *> *selectedIdxArr = [NSMutableArray arrayWithArray:self.disPlayFuncConfigModel.selectedFuncIDs];
    [selectedIdxArr removeObject:funcModel.functionID];
    [self.selectedFuncModelArray removeObject:funcModel];
    self.disPlayFuncConfigModel.selectedFuncIDs = selectedIdxArr.copy;
    // 在可选区域移除显示
    self.disPlayFuncConfigModel.groupData = [self publicGetOptionFuncsWithSelectedFuncIDs:self.disPlayFuncConfigModel.selectedFuncIDs];
    [self reloadFuncsView];
    
    // 返回功能变更状态
    BOOL isChanged = [self publickCheckQuickFuncsChanged];
    if ([self.fmDelegate respondsToSelector:@selector(funcConfigChanged:)]) {
        [self.fmDelegate funcConfigChanged:isChanged];
    }
}
// 添加元素
- (void)addFunc:(GYFunctionModel *)funcModel opIndexPath:(NSIndexPath *)opIndexPath
{
    GYWarnLog(@"从可选区域添加第[%zd]个功能: %@", opIndexPath.item + 1, funcModel.functionName);
    // 在已选取区域展示
    NSMutableArray <NSNumber *> *selectedIdxArr = [NSMutableArray arrayWithArray:self.disPlayFuncConfigModel.selectedFuncIDs];
    [selectedIdxArr addObject:funcModel.functionID];
    [self.selectedFuncModelArray addObject:funcModel];
    self.disPlayFuncConfigModel.selectedFuncIDs = selectedIdxArr.copy;
    // 在可选区域移除显示
    self.disPlayFuncConfigModel.groupData = [self publicGetOptionFuncsWithSelectedFuncIDs:self.disPlayFuncConfigModel.selectedFuncIDs];
    [self reloadFuncsView];
    
    // 返回功能变更状态
    BOOL isChanged = [self publickCheckQuickFuncsChanged];
    if ([self.fmDelegate respondsToSelector:@selector(funcConfigChanged:)]) {
        [self.fmDelegate funcConfigChanged:isChanged];
    }
}
// 调整展示顺序
- (void)changeFuncItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)desIndexPath
{
    if (!sourceIndexPath || !desIndexPath) {
        return;
    }
    if (sourceIndexPath.item == desIndexPath.item) {
        return;
    }
    NSMutableArray <NSNumber *> *selectedIdxArr = [NSMutableArray arrayWithArray:self.disPlayFuncConfigModel.selectedFuncIDs];
    int offset = (int)(sourceIndexPath.item - desIndexPath.item);
    if ( abs(offset) == 1) {
        // 相邻互换
        NSNumber *temp = selectedIdxArr[sourceIndexPath.item];
        selectedIdxArr[sourceIndexPath.item] = selectedIdxArr[desIndexPath.item];
        selectedIdxArr[desIndexPath.item] = temp;
        GYWarnLog(@"相邻互换, source: %zd  des: %zd", sourceIndexPath.item, desIndexPath.item);
    }
    else {
        NSNumber *sourceFuncID = selectedIdxArr[sourceIndexPath.item];
        [selectedIdxArr removeObjectAtIndex:sourceIndexPath.item];
        if (desIndexPath.item >= selectedIdxArr.count) {
            [selectedIdxArr addObject:sourceFuncID];
        }
        else {
            [selectedIdxArr insertObject:sourceFuncID atIndex:desIndexPath.item];
        }
        GYWarnLog(@"非相邻调整, source: %zd  des: %zd ", sourceIndexPath.item, desIndexPath.item);
    }
    self.disPlayFuncConfigModel.selectedFuncIDs = selectedIdxArr.copy;
    self.selectedFuncModelArray = [self publicGetAllSelectedFuncsWithFuncIDs:selectedIdxArr];
    
    // 返回功能变更状态
    BOOL isChanged = [self publickCheckQuickFuncsChanged];
    if ([self.fmDelegate respondsToSelector:@selector(funcConfigChanged:)]) {
        [self.fmDelegate funcConfigChanged:isChanged];
    }
}
- (void)targetForDisplayFuncCollectionViewGesture:(UILongPressGestureRecognizer *)gesture
{
    if (!self.isEditState) {
        // 进入编辑状态
        if ([self.fmDelegate respondsToSelector:@selector(funcUneditStateLongPressHandler)]) {
            [self.fmDelegate funcUneditStateLongPressHandler];
        }
        return;
    }
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            //GYDebugLog(@"UIGestureRecognizerStateBegan");
            CGPoint location = [gesture locationInView:self.fmDisplayedFuncsCollectionView];
            // 找到当前点击的cell的位置
            NSIndexPath *indexPath = [self.fmDisplayedFuncsCollectionView indexPathForItemAtPoint:location];
            if (indexPath == nil) return;
            self.currentIndexPath = indexPath;
            self.sourceIndexPath  = indexPath;
            
            UICollectionViewCell *targetCell = [self.fmDisplayedFuncsCollectionView cellForItemAtIndexPath:self.currentIndexPath];
            self.snapshotFuncItem = [targetCell snapshotViewAfterScreenUpdates:YES];
            targetCell.hidden = YES;
            [self.fmDisplayedFuncsCollectionView addSubview:self.snapshotFuncItem];
            self.snapshotFuncItem.transform = CGAffineTransformMakeScale(1.1, 1.1);
            self.snapshotFuncItem.center = targetCell.center;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            //GYDebugLog(@"UIGestureRecognizerStateChanged");
            CGPoint point = [gesture locationInView:self.fmDisplayedFuncsCollectionView];
            self.snapshotFuncItem.center = point;
            NSIndexPath *indexPath = [self.fmDisplayedFuncsCollectionView indexPathForItemAtPoint:point];
            if (indexPath == nil || !self.currentIndexPath)  return;
            if (indexPath.section == self.currentIndexPath.section) {
                // 移动的方法
                [self.fmDisplayedFuncsCollectionView moveItemAtIndexPath:self.currentIndexPath toIndexPath:indexPath];
                self.currentIndexPath = indexPath;
            }
        }
            break;
        case UIGestureRecognizerStateEnded: {
            //GYDebugLog(@"UIGestureRecognizerStateEnded");
            UICollectionViewCell *sourceCell = [self.fmDisplayedFuncsCollectionView cellForItemAtIndexPath:self.currentIndexPath];
            // 手势结束后，把截图隐藏，显示出原先的cell
            [UIView animateWithDuration:0.25 animations:^{
                self.snapshotFuncItem.center = sourceCell.center;
            } completion:^(BOOL finished) {
                // 更新数据源
                [self changeFuncItemAtIndexPath:self.sourceIndexPath toIndexPath:self.currentIndexPath];
                
                [self.snapshotFuncItem removeFromSuperview];
                sourceCell.hidden     = NO;
                self.snapshotFuncItem = nil;
                self.currentIndexPath = nil;
                self.sourceIndexPath  = nil;
                [self.fmDisplayedFuncsCollectionView reloadData];
            }];
        }
            break;
        default:
            break;
    }
}

- (void)targetForOptionalFuncCollectionViewGesture:(UILongPressGestureRecognizer *)gesture
{
    if (!self.isEditState) {
        // 进入编辑状态
        if ([self.fmDelegate respondsToSelector:@selector(funcUneditStateLongPressHandler)]) {
            [self.fmDelegate funcUneditStateLongPressHandler];
        }
        return;
    }
}

#pragma mark - outSide target
// 取消编辑
- (void)cancelEdit
{
    [self initData];
    self.editState = NO;
    
    // 返回功能变更状态
    if ([self.fmDelegate respondsToSelector:@selector(funcConfigChanged:)]) {
        [self.fmDelegate funcConfigChanged:NO];
    }
}
// 保存
- (void)saveEdit
{
    NSMutableArray <NSNumber *> *selectedIdsArr = self.disPlayFuncConfigModel.selectedFuncIDs.copy;
    self.originalFuncConfigModel.selectedFuncIDs = selectedIdsArr.copy;
    self.editState = NO;
    
    NSDictionary *userInfo = @{kNotificationNewFucsConfigModelKey: self.originalFuncConfigModel};
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUpdateDisplayFuncs object:nil userInfo:userInfo];
    // 持久化
    [[GYFunctionManager shareManager] toolArchiveFuncConfig:self.originalFuncConfigModel];
    
    // 返回功能变更状态
    if ([self.fmDelegate respondsToSelector:@selector(funcConfigChanged:)]) {
        [self.fmDelegate funcConfigChanged:NO];
    }
}


#pragma mark

#pragma mark - setter

- (void)setEditState:(BOOL)editState
{
    _editState = editState;
    [self reloadFuncsView];
}
- (void)setDisPlayFuncConfigModel:(GYFuncConfigModel *)disPlayFuncConfigModel
{
    _disPlayFuncConfigModel = disPlayFuncConfigModel;
    [self reloadFuncsView];
}
- (void)setSelectedFuncModelArray:(NSMutableArray<GYFunctionModel *> *)selectedFuncModelArray
{
    _selectedFuncModelArray = selectedFuncModelArray;
    [self.fmDisplayedFuncsCollectionView reloadData];
}

#pragma mark

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
//    [collectionView.collectionViewLayout invalidateLayout];
    if (collectionView == self.fmOptionalCollectonView) {
        return self.disPlayFuncConfigModel.groupData.count;
    }
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView == self.fmOptionalCollectonView) {
        return self.disPlayFuncConfigModel.groupData[section].funcData.count;
    }
    return kSelectedFuncMaxCount;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    GYFunctionModel *funcModel = nil;
    __weak typeof(self) weakSelf = self;
    // 已选区域
    if (collectionView == self.fmDisplayedFuncsCollectionView) {
        if (indexPath.row < self.selectedFuncModelArray.count) {
            funcModel = self.selectedFuncModelArray[indexPath.row];
            GYFuncManagementRemoveCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kSelectedFunctionCellReusedID forIndexPath:indexPath];
            cell.functionModel = funcModel;
            cell.editingState  = self.isEditState;
            cell.backgroundColor = WHITE_COLOR;
            [cell setRemoveFunctionBlock:^(GYFunctionModel * _Nonnull removeFuncModel) {
                [weakSelf removeFunc:removeFuncModel disIndexPath:indexPath];
            }];
            return cell;
        }
        GYTBDFunctionCell *tbdCell = [collectionView dequeueReusableCellWithReuseIdentifier:kTBDFunctionCellReusedID forIndexPath:indexPath];
        tbdCell.backgroundColor = WHITE_COLOR;
        return tbdCell;
    }
    // 可选区域
    if (collectionView == self.fmOptionalCollectonView) {
        funcModel = self.disPlayFuncConfigModel.groupData[indexPath.section].funcData[indexPath.item];
        GYFuncManagementAddCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFuncManagementOptionalCellReusedID forIndexPath:indexPath];
        cell.functionModel = funcModel;
        cell.editingState = self.isEditState;
        cell.backgroundColor = WHITE_COLOR;
        // 添加功能回调
        [cell setAddFunctionBlock:^(GYFunctionModel * _Nonnull addFuncModel) {
            GYDebugLog(@"添加功能名称: [%@]", addFuncModel.functionName);
            if (weakSelf.selectedFuncModelArray.count >= 5) {
                if ([weakSelf.fmDelegate respondsToSelector:@selector(funcExceededLimit)]) {
                    [weakSelf.fmDelegate funcExceededLimit];
                }
            }
            else {
                [weakSelf addFunc:addFuncModel opIndexPath:indexPath];
            }
        }];
        return cell;
    }
    return [UICollectionViewCell new];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.isEditState) {
        return;
    }
    GYFunctionModel *functionModel = nil;
    if (collectionView == self.fmOptionalCollectonView) {
        functionModel = self.disPlayFuncConfigModel.groupData[indexPath.section].funcData[indexPath.item];
    }
    else {
        functionModel = self.selectedFuncModelArray[indexPath.item];
    }
    // 执行某个功能回调
    if ([self.fmDelegate respondsToSelector:@selector(funcExecuteFunction:)]) {
        [self.fmDelegate funcExecuteFunction:functionModel];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        GYFuncManagementNormalSectionHeaderView *headView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFuncManagementNormalSectionHeaderReusedID forIndexPath:indexPath];
        GYFunctionGroupModel *groupModel = self.disPlayFuncConfigModel.groupData[indexPath.section];
        headView.headLabel.text = groupModel.groupTitle;
        return headView;
    }
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        // 最后的 -没有啦-
        if (indexPath.section == self.disPlayFuncConfigModel.groupData.count - 1) {
            GYFuncManagementLastSectionFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFuncManagementNoMoreSectionFooterReusedID forIndexPath:indexPath];
            return footView;
        }
        GYFuncManagementNormalSectionFooterView *footView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFuncManagementNormalSectionFooterReusedID forIndexPath:indexPath];
        return footView;
    }
    return nil;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (collectionView == self.fmOptionalCollectonView) {
        if (self.disPlayFuncConfigModel.groupData[section].funcData.count) {
            return CGSizeMake(SCREEN_WIDTH, 45);
        }
    }
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (collectionView == self.fmOptionalCollectonView) {
        // 最后的 -没有啦-
        if (section == self.disPlayFuncConfigModel.groupData.count - 1) {
            return CGSizeMake(SCREEN_WIDTH, STATUS_BAR_HEIGHT + 50);
        }
        return CGSizeZero;
    }
    return CGSizeZero;
}

#pragma mark

#pragma mark - lazy
- (UILabel *)headTitleLabel {
    if (!_headTitleLabel) {
        _headTitleLabel                 = [UILabel new];
        _headTitleLabel.frame           = CGRectMake(50, 0, SCREEN_WIDTH - 100, 66);
        _headTitleLabel.font            = [UIFont systemFontOfSize:13];
        _headTitleLabel.textAlignment   = NSTextAlignmentCenter;
        _headTitleLabel.textColor       = [UIColor grayColor];
        _headTitleLabel.numberOfLines   = 0;
        _headTitleLabel.text            = @"你可以将常用的功能添加到快捷登录首页, 也可以按住拖动调整功能的顺序";
        _headTitleLabel.backgroundColor = WHITE_COLOR;
    }
    return _headTitleLabel;
}
- (UILabel *)moreFuncsLabel {
    if (!_moreFuncsLabel) {
        _moreFuncsLabel                 = [UILabel new];
        _moreFuncsLabel.frame           = CGRectMake(0, self.headTitleLabel.height + self.fmDisplayedFuncsCollectionView.height + self.seperatorView.height, SCREEN_WIDTH, 60);
        _moreFuncsLabel.font            = [UIFont boldSystemFontOfSize:16];
        _moreFuncsLabel.textAlignment   = NSTextAlignmentCenter;
        _moreFuncsLabel.textColor       = BLACK_COLOR;
        _moreFuncsLabel.numberOfLines   = 1;
        _moreFuncsLabel.text            = @"更多功能";
    }
    return _moreFuncsLabel;
}
- (UIView *)seperatorView {
    if (!_seperatorView) {
        _seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headTitleLabel.height + self.fmDisplayedFuncsCollectionView.height, SCREEN_WIDTH, 10)];
        _seperatorView.backgroundColor = COMMON_SCHEME_BG_COLOR;
    }
    return _seperatorView;
}
- (UICollectionView *)fmDisplayedFuncsCollectionView {
    if (!_fmDisplayedFuncsCollectionView) {
        _fmDisplayedFuncsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[GYFuncManagementLayout new]];
        CGFloat featureItemW         = 0;
        CGFloat featureItemH         = 0;
        CGFloat collectionViewH      = 0;
        if (IS_IPAD) {
            featureItemW             = (SCREEN_WIDTH - 2 * kFuncHorizontalPadding - 5 * kFuncItemSpacing) / kFuncIPadRowItemCount;
            featureItemH             = (featureItemW * kFuncManagementItemH) / kFuncManagementItemW;
            collectionViewH          = featureItemH + kFuncVerticalPadding * 2;
        }
        else {
            featureItemW             = (SCREEN_WIDTH - 2 * kFuncHorizontalPadding - 2 * kFuncItemSpacing) / kFuncIPhoneRowItemCount;
            featureItemH             = (featureItemW * kFuncManagementItemH) / kFuncManagementItemW;
            collectionViewH          = featureItemH * 2 + kFuncVerticalPadding * 2 + kFuncLineSpacing;
        }
        _fmDisplayedFuncsCollectionView.frame = CGRectMake(0, self.headTitleLabel.height, SCREEN_WIDTH, collectionViewH);
        if (@available(iOS 11.0, *)) {
            _fmDisplayedFuncsCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            _fmDisplayedFuncsCollectionView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
        _fmDisplayedFuncsCollectionView.backgroundColor = WHITE_COLOR;
        _fmDisplayedFuncsCollectionView.dataSource      = self;
        _fmDisplayedFuncsCollectionView.delegate        = self;
        // Cell
        [_fmDisplayedFuncsCollectionView registerClass:[GYFuncManagementRemoveCell class] forCellWithReuseIdentifier:kSelectedFunctionCellReusedID];
        [_fmDisplayedFuncsCollectionView registerClass:[GYTBDFunctionCell class] forCellWithReuseIdentifier:kTBDFunctionCellReusedID];
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(targetForDisplayFuncCollectionViewGesture:)];
        longPressGesture.minimumPressDuration = 0.3f; //时间长短
        [_fmDisplayedFuncsCollectionView addGestureRecognizer:longPressGesture];
    }
    return _fmDisplayedFuncsCollectionView;
}
- (UIView *)selectedFuncsView {
    if (!_selectedFuncsView) {
        _selectedFuncsView       = [[UIView alloc] init];
        _selectedFuncsView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.headTitleLabel.height + self.fmDisplayedFuncsCollectionView.height + self.seperatorView.height + self.moreFuncsLabel.height);
        _selectedFuncsView.backgroundColor = [UIColor whiteColor];
        
        [_selectedFuncsView addSubview:self.headTitleLabel];
        [_selectedFuncsView addSubview:self.fmDisplayedFuncsCollectionView];
        [_selectedFuncsView addSubview:self.seperatorView];
        [_selectedFuncsView addSubview:self.moreFuncsLabel];
    }
    return _selectedFuncsView;
}
- (UICollectionView *)fmOptionalCollectonView {
    if (!_fmOptionalCollectonView) {
        _fmOptionalCollectonView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[GYFuncManagementLayout new]];
        _fmOptionalCollectonView.frame = CGRectMake(0, self.selectedFuncsView.height, SCREEN_WIDTH, self.height - self.selectedFuncsView.height);
        if (@available(iOS 11.0, *)) {
            _fmOptionalCollectonView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        if (@available(iOS 13.0, *)) {
            _fmOptionalCollectonView.automaticallyAdjustsScrollIndicatorInsets = NO;
        }
        _fmOptionalCollectonView.backgroundColor = WHITE_COLOR;
        _fmOptionalCollectonView.dataSource      = self;
        _fmOptionalCollectonView.delegate        = self;
        
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(targetForOptionalFuncCollectionViewGesture:)];
        longPressGesture.minimumPressDuration = 0.3f;
        [_fmOptionalCollectonView addGestureRecognizer:longPressGesture];
        
        // Cell
        [_fmOptionalCollectonView registerClass:[GYFuncManagementAddCell class] forCellWithReuseIdentifier:kFuncManagementOptionalCellReusedID];
        
        // header和footer
        [_fmOptionalCollectonView registerClass:[GYFuncManagementNormalSectionHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kFuncManagementNormalSectionHeaderReusedID];
        [_fmOptionalCollectonView registerClass:[GYFuncManagementNormalSectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFuncManagementNormalSectionFooterReusedID];
        [_fmOptionalCollectonView registerClass:[GYFuncManagementLastSectionFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kFuncManagementNoMoreSectionFooterReusedID];
    }
    return _fmOptionalCollectonView;
}

@end
