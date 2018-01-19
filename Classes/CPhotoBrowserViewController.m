//
//  CPhotoBrowserViewController.m
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/20.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import "CPhotoBrowserViewController.h"
#import "CPhotoAsset.h"
#import "CPhotoBrowserCell.h"
#import "UIView+Addition.h"
#import "CPhotoDataManager.h"
#import "CPickerHeader.h"

#define kViewWidth self.view.frame.size.width

@interface CPhotoBrowserViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate>
{
    UICollectionView *_collectionView;
    UIButton *_rightSelectBtn;
    UIButton *_sendBtn;
}
@end

@implementation CPhotoBrowserViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self configUI];
    [self configNavBar];
    [self configTabbar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_currentIndex != 0) {
        [_collectionView setContentOffset:CGPointMake((self.view.c_width + 20) * _currentIndex, 0) animated:NO];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];
    id asset = _dataArray[_currentIndex];
    NSString *UID = [CPhotoDataManager getAssetIdentifier: asset];
    
    for (CPhotoAsset *photoAsset in _selecteAssets) {
        if ([photoAsset.uniqueID isEqualToString: UID]) {
            _rightSelectBtn.selected = YES;
            break;
        }
    }
    [self refreshNaviBarState];
}

- (void)configNavBar {
    self.navigationController.navigationBarHidden = YES;
    UIView *navView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, kCPickerNavH)];
    [self.view addSubview: navView];
    
    {
        UIView *maskView = [[UIView alloc] initWithFrame: navView.bounds];
        maskView.backgroundColor = [UIColor whiteColor];
        [navView addSubview: maskView];
    }
    
    {
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, navView.c_height - 0.5, navView.c_width, 0.5)];
        [navView addSubview: lineImgView];
        lineImgView.backgroundColor = [UIColor lightGrayColor];
    }
    
    {
        UIButton *returnBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [returnBtn setTitle: @"返回" forState: UIControlStateNormal];
        [returnBtn addTarget: self action: @selector(returnBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [navView addSubview: returnBtn];
        returnBtn.frame = CGRectMake(0, kCPickerNavMargin, 50, 44);
        returnBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
        [returnBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    }
    
    {
        UIButton *selectBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [selectBtn addTarget: self action: @selector(selectBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [navView addSubview: selectBtn];
        selectBtn.frame = CGRectMake(navView.frame.size.width - 27 - 10, kCPickerNavMargin + 8, 27, 27);
        _rightSelectBtn = selectBtn;
        [selectBtn setBackgroundImage: kCImageQuickName(@"gridCell_unSelect") forState: UIControlStateNormal];
        [selectBtn setBackgroundImage: kCImageQuickName(@"gridCell_select") forState: UIControlStateSelected];
        selectBtn.selected = NO;
    }
}

- (void)configTabbar {
    UIView *tabbarView = [[UIView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - kCPickerSpecTabH, self.view.frame.size.width, kCPickerSpecTabH)];
    tabbarView.backgroundColor = [UIColor clearColor];
    [self.view addSubview: tabbarView];
    
    {
        UIView *maskView = [[UIView alloc] initWithFrame: tabbarView.bounds];
        maskView.backgroundColor = [UIColor whiteColor];
        [tabbarView addSubview: maskView];
    }
    
    {
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, tabbarView.c_width, 0.5)];
        [tabbarView addSubview: lineImgView];
        lineImgView.backgroundColor = [UIColor lightGrayColor];
    }
    
    {
        UIButton *sendBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        NSString *str = [NSString stringWithFormat:  @"完成(%zi/%zi)",_selecteAssets.count,_maxSelectCount];
        sendBtn.enabled = NO;
        [sendBtn setTitle: str forState: UIControlStateNormal];
        [sendBtn addTarget: self action: @selector(sendBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [tabbarView addSubview: sendBtn];
        sendBtn.frame = CGRectMake(tabbarView.frame.size.width - 80 - 10, 0, 80, 40);
        sendBtn.titleLabel.font = [UIFont systemFontOfSize: 16];
        [sendBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [sendBtn setTitleColor: [UIColor lightGrayColor] forState:UIControlStateDisabled];
        _sendBtn = sendBtn;
    }
}

- (void)configUI {
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(self.view.c_width + 20, self.view.c_height - kCPickerNavH - 40);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    
    _collectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(- 10, 64, self.view.c_width + 20, self.view.c_height - 64 - 40) collectionViewLayout:layout];
    [_collectionView registerClass: [CPhotoBrowserCell class] forCellWithReuseIdentifier: @"CPhotoBrowserCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
    [_collectionView reloadData];
}


#pragma mark --- UIButton Actions

- (void)returnBtnClick {
    self.onSelectedPhotos(_selecteAssets);
    [self.navigationController popViewControllerAnimated: YES];
}

- (void)selectBtnClick {
    
    if (_selecteAssets.count == _maxSelectCount && _rightSelectBtn.isSelected == NO) {
        [SVProgressHUD setMinimumDismissTimeInterval:1.0];
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"你最多只能选择%zi张照片", _maxSelectCount]];
        return;
    }
    _rightSelectBtn.selected = !_rightSelectBtn.selected;

    CPhotoBrowserCell *browserCell = (CPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath: [NSIndexPath indexPathForItem: _currentIndex inSection: 0]];

    if (_rightSelectBtn.isSelected) {
        
        CPhotoAsset *currentAsset = [[CPhotoAsset alloc] init];
        currentAsset.photoName = [CPhotoDataManager getImageNameFromAsset: browserCell.photoAsset];
        currentAsset.uniqueID = [CPhotoDataManager getAssetIdentifier: browserCell.photoAsset];
        currentAsset.photoAsset = browserCell.photoAsset;
        [_selecteAssets addObject: currentAsset];
        
    } else {
        
        NSString *currentAssetUID = [CPhotoDataManager getAssetIdentifier: browserCell.photoAsset];
        
        for (CPhotoAsset *photoAsset in _selecteAssets) {
            if ([photoAsset.uniqueID isEqualToString: currentAssetUID]) {
                [_selecteAssets removeObject: photoAsset];
                break;
            }
        }
    }
    
    [self refreshNaviBarState];
}

- (void)sendBtnClick {
    NSMutableArray *assetsArray = [NSMutableArray arrayWithCapacity: _selecteAssets.count];
    
    for (CPhotoAsset *selectAsset in _selecteAssets) {
        
        [assetsArray addObject: selectAsset.photoAsset];
    }
    // 多图
    if (_onCommitPhotos) {
        _onCommitPhotos([assetsArray mutableCopy]);
    }
}

- (void)refreshNaviBarState {
    
    BOOL hited = NO;
    
    CPhotoBrowserCell *browserCell = (CPhotoBrowserCell *)[_collectionView cellForItemAtIndexPath: [NSIndexPath indexPathForItem: _currentIndex inSection: 0]];

    NSString *currentAssetUID = [CPhotoDataManager getAssetIdentifier: browserCell.photoAsset];
    
    for (CPhotoAsset *photoAsset in _selecteAssets) {
        if ([photoAsset.uniqueID isEqualToString: currentAssetUID]) {
            hited = YES;
            break;
        }
    }
    
    _rightSelectBtn.selected = hited;

    NSString *str = [NSString stringWithFormat:  @"完成(%zi/%zi)",_selecteAssets.count,_maxSelectCount];
    _sendBtn.enabled = _selecteAssets.count > 0 ? YES : NO;
    [_sendBtn setTitle: str forState: UIControlStateNormal];
}

#pragma mark - UICollection DataSource & delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CPhotoBrowserCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CPhotoBrowserCell" forIndexPath:indexPath];
    cell.photoAsset = _dataArray[indexPath.item];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [(CPhotoBrowserCell *)cell resetUI];
    
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [(CPhotoBrowserCell *)cell resetUI];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetWidth = scrollView.contentOffset.x;
    offSetWidth = offSetWidth +  ((self.view.c_width + 20) * 0.5);
    
    NSInteger currentIndex = offSetWidth / (self.view.c_width + 20);
    _currentIndex = currentIndex;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self refreshNaviBarState];
}


@end
