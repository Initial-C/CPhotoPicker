//
//  CPhotoGridViewController.m
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/18.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import "CPhotoGridViewController.h"
#import "CPhotoDataManager.h"
#import "CPhotoGridCell.h"
#import "CPhotoBrowserViewController.h"
#import "CAlbumDropView.h"
#import "CPhotoAsset.h"
#import "UIView+Addition.h"
#import "CPickerHeader.h"
#import "CPickerHeader.h"

static NSString *const cellIdentifier = @"CPhotoGridCell";

@interface CPhotoGridViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    NSArray * _dataArray;
    UICollectionView * _listCollectionView;
    NSMutableArray <CPhotoAsset *>* _selectedArray;
    
    UIButton *_browserBtn;
    UIButton *_sureBtn;
    UIButton *_cameraBtn;
    UIView *_navBarView;
    UIImageView *_arrowImgView;
    UILabel *_titleLabel;
    
    BOOL _hadShowAlbumListView;
}

@property (nonatomic, strong) CAlbumDropView *albumsView;


@end

@implementation CPhotoGridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _selectedArray = [@[] mutableCopy];
    self.view.backgroundColor = [UIColor whiteColor];

    [self configUI];
    if (_maxSelectCount != 1) {
        [self configTabbar];
    }
    [self configNavBar];

    [self loadData];
}

- (void)loadData {
    [CPhotoDataManager shareInstance].bReverse = YES;
    
    if (_albumData) {
        
        [self reloaddDsignatedDataPhotos];
    } else {
        
        [[CPhotoDataManager shareInstance] fetchCameraRollPhotoList:^(NSArray * photoList) {
            _dataArray = photoList;
            [_listCollectionView reloadData];
        }];
    }
    
    dispatch_queue_t global_t = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(global_t, ^{
        
        [[CPhotoDataManager shareInstance] fetchAllPhotoAlbumsList:^(NSArray * allGroups) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.albumsView.dataArray = allGroups;
            });
        }];
    });
}

- (void)configNavBar {
    self.navigationController.navigationBarHidden = YES;
    UIView *navView = [[UIView alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 64)];
    navView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: navView];
    _navBarView = navView;
    
    {
        UIButton *backToListBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        
        [backToListBtn setTitle: @"取消" forState: UIControlStateNormal];
        [backToListBtn addTarget: self action: @selector(cancelBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [navView addSubview: backToListBtn];
        [backToListBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        backToListBtn.frame = CGRectMake(0, 24, 50, 40);
        backToListBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
        _cameraBtn = backToListBtn;
    }
    /*
    {
        UIButton *cancelBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [cancelBtn setTitle: @"取消" forState: UIControlStateNormal];
        [cancelBtn addTarget: self action: @selector(cancelBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [navView addSubview: cancelBtn];
        [cancelBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        cancelBtn.frame = CGRectMake(navView.frame.size.width - 50 - 10, 24, 50, 40);
        cancelBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
    }
    */
    {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame: CGRectMake(navView.frame.size.width / 2 - 75, 20, 150, 44)];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize: 18];
        titleLabel.text = @"所有照片";
        [navView addSubview: titleLabel];
        titleLabel.userInteractionEnabled = YES;
        [titleLabel sizeToFit];
        _titleLabel = titleLabel;

        _titleLabel.frame = CGRectMake(navView.frame.size.width / 2 - _titleLabel.width / 2, 20, _titleLabel.width, 44);
        
        UITapGestureRecognizer *titleTapGes = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapTitleAction)];
        [titleLabel addGestureRecognizer: titleTapGes];
    }
    
    {
        _arrowImgView = [[UIImageView alloc] initWithFrame: CGRectMake(_titleLabel.maxX + 3, 0, 13.5, 8)];
        [navView addSubview: _arrowImgView];
        _arrowImgView.centerY = _titleLabel.centerY;
        _arrowImgView.image = kCImageQuickName(@"arrow");
        _arrowImgView.userInteractionEnabled = YES;
        [_arrowImgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapTitleAction)]];
    }
    
    {
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, navView.height - 0.5, navView.width, 0.5)];
        [navView addSubview: lineImgView];
        lineImgView.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)configTabbar {
    UIView *tabbarView = [[UIView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - 40, self.view.frame.size.width, 40)];
    tabbarView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: tabbarView];
    
    {
        UIButton *browserBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        [browserBtn setTitle: @"预览" forState: UIControlStateNormal];
        [browserBtn addTarget: self action: @selector(browserBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [tabbarView addSubview: browserBtn];
        browserBtn.frame = CGRectMake(10, 0, 50, 40);
        browserBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
        [browserBtn setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
        _browserBtn = browserBtn;
        _browserBtn.enabled = NO;
    }
    
    {
        UIButton *sureBtn = [UIButton buttonWithType: UIButtonTypeCustom];
        
        NSString *str = [NSString stringWithFormat:  @"完成(0/%ld)",_maxSelectCount];
        [sureBtn setTitle: str forState: UIControlStateNormal];
        [sureBtn addTarget: self action: @selector(sureBtnClick) forControlEvents: UIControlEventTouchUpInside];
        [tabbarView addSubview: sureBtn];
        sureBtn.frame = CGRectMake(tabbarView.frame.size.width - 80 - 10, 0, 80, 40);
        sureBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
        [sureBtn setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
        _sureBtn = sureBtn;
        _sureBtn.enabled =NO;
    }
    {
        UIImageView *lineImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, tabbarView.width, 0.5)];
        [tabbarView addSubview: lineImgView];
        lineImgView.backgroundColor = [UIColor lightGrayColor];
    }
}

- (void)configUI {
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(PhotoCellWidth, PhotoCellWidth);
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 5;
    flowLayout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    
    _listCollectionView = [[UICollectionView alloc] initWithFrame: CGRectMake(0, 64, self.view.width, self.view.height - 64 - 40) collectionViewLayout: flowLayout];
    _listCollectionView.prefetchingEnabled = NO;
    _listCollectionView.dataSource  = self;
    _listCollectionView.delegate = self;
    _listCollectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview: _listCollectionView];
    [_listCollectionView registerClass: [CPhotoGridCell class] forCellWithReuseIdentifier: cellIdentifier];
}

#pragma mark --- tool method

- (void)reloaddDsignatedDataPhotos {
    [[CPhotoDataManager shareInstance] fetchPhotoListOfAlbumData: _albumData result:^(NSArray * photoList) {
        _dataArray = photoList;
        [_listCollectionView reloadData];
    }];
}

- (void)checkBtnState {
    if (_selectedArray.count > 0) {
        _sureBtn.enabled = _browserBtn.enabled = YES;
        _sureBtn.selected = _browserBtn.selected = YES;
        [_sureBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [_browserBtn setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    } else {
        _sureBtn.enabled = _browserBtn.enabled = NO;
        _sureBtn.selected = _browserBtn.selected = NO;
        [_sureBtn setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
        [_browserBtn setTitleColor: [UIColor lightGrayColor] forState: UIControlStateNormal];
    }
    
    NSString *str = [NSString stringWithFormat:  @"完成(%ld/%ld)",_selectedArray.count,_maxSelectCount];
    [_sureBtn setTitle: str forState: UIControlStateNormal];
}

- (CAlbumDropView *)albumsView {
    if (!_albumsView) {
        CAlbumDropView * albumView = [[CAlbumDropView alloc] initWithFrame: CGRectMake(0, 64 - self.view.height, self.view.width, self.view.height - 64)];
        albumView.userInteractionEnabled = NO;
        [self.view insertSubview: albumView belowSubview: _navBarView];
        
        _albumsView = albumView;
        [_arrowImgView.layer removeAllAnimations];
        __weak typeof(self) weakSelf = self;
        _albumsView.selecteHandler = ^(id albumData) {
            [weakSelf handleSelectAlbumData: albumData];
        };
    }
    return _albumsView;
}

- (void)showAlbumListView {
    _hadShowAlbumListView = YES;
    self.view.userInteractionEnabled = NO;
    _cameraBtn.hidden = YES;
    [self.view insertSubview: self.albumsView belowSubview: _navBarView];

    [UIView animateWithDuration: 0.3f animations:^{
        self.albumsView.y = 64;
        _arrowImgView.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        self.albumsView.userInteractionEnabled = YES;
        self.view.userInteractionEnabled = YES;
    }];
}

- (void)dismissAlbumsListView {
    _cameraBtn.hidden = NO;

    [UIView animateWithDuration: 0.3f animations:^{
        
        self.albumsView.y = 64 - [UIScreen mainScreen].bounds.size.height;
        _arrowImgView.transform = CGAffineTransformIdentity;

    } completion:^(BOOL finished) {
        
        self.view.userInteractionEnabled = YES;
        
        [self.albumsView removeFromSuperview];
        [_arrowImgView.layer addAnimation:[self getIconAnimation] forKey:@"move"];
        _hadShowAlbumListView = NO;

    }];
}

- (CAAnimation*)getIconAnimation {
    CAKeyframeAnimation* anim = [CAKeyframeAnimation animationWithKeyPath:@"transform.translation.y"];
    anim.values = @[@0,@2.0f,@0,@2.0,@0,@0];
    anim.keyTimes = @[@0,@(0.25f/6.0f),@(0.5/6.0f),@(0.75f/6.0f),@(1.0f/6.0f),@1.0f];
    anim.duration = 6.0f;
    anim.repeatCount = MAXFLOAT;
    anim.removedOnCompletion = NO;
    return anim;
}

- (void)handleSelectAlbumData:(id)data {
    [self dismissAlbumsListView];
    
    if (data) {
        _albumData = data;
        [self reloaddDsignatedDataPhotos];
       
        [[CPhotoDataManager shareInstance] fetchAlbumInfoWithThumbImgSize: CGSizeZero albumData: data fetchResult:^(NSDictionary * infoDic) {
           
            _titleLabel.text = infoDic[kPDMAlbumInfoNameKey];
            [_titleLabel sizeToFit];
            _titleLabel.frame = CGRectMake(_navBarView.frame.size.width / 2 - _titleLabel.width / 2, 20, _titleLabel.width, 44);
            _arrowImgView.frame = CGRectMake(_titleLabel.maxX + 3, 0, 13.5, 8);
            _arrowImgView.centerY  =_titleLabel.centerY;
        }];
    }
}

#pragma mark --- handle event action ---

- (void)tapTitleAction {
    
    if (_hadShowAlbumListView) {
        [self dismissAlbumsListView];
    } else {
        [self showAlbumListView];
    }

}

- (void)cancelBtnClick {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void)sureBtnClick {
    
    NSMutableArray *assetsArray = [NSMutableArray arrayWithCapacity: _selectedArray.count];

    for (CPhotoAsset *selectAsset in _selectedArray) {
        
        [assetsArray addObject: selectAsset.photoAsset];
    }
    // 多图
    if (_selectedCompletion) {
        _selectedCompletion(assetsArray ,NO);
    }
    [self cancelBtnClick];
}

- (void)browserBtnClick {
    NSMutableArray *assetsArray = [NSMutableArray arrayWithCapacity: _selectedArray.count];
    
    for (CPhotoAsset *selectAsset in _selectedArray) {
        
        [assetsArray addObject: selectAsset.photoAsset];
    }
    
    [self showBrowserVCWithDataArray: assetsArray selectIndex: 0];
}

- (void)showBrowserVCWithDataArray:(NSArray *)dataArray selectIndex:(NSInteger)selectIndex {
    CPhotoBrowserViewController *browserVC = [[CPhotoBrowserViewController alloc] init];
    browserVC.dataArray = dataArray;
    browserVC.maxSelectCount = _maxSelectCount;
    browserVC.selecteAssets = [_selectedArray mutableCopy];
    browserVC.currentIndex = selectIndex;
    [self.navigationController pushViewController: browserVC animated: YES];
    
    browserVC.onSelectedPhotos = ^(NSArray *resultSelectAssets){
        [_selectedArray removeAllObjects];
        [_selectedArray addObjectsFromArray: resultSelectAssets];
        [_listCollectionView reloadData];
        [self checkBtnState];
    };
    // 预览图
    __weak typeof(self) weakSelf = self;
    browserVC.onCommitPhotos = ^(NSArray *resultArray) {
        
        weakSelf.selectedCompletion(resultArray,NO);
        
        [weakSelf cancelBtnClick];
    };
}

#pragma mark --- data source ---

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _dataArray.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    CPhotoGridCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier: cellIdentifier forIndexPath: indexPath];
    if (indexPath.item == nil) {
        cell.photoAsset = kCImageQuickName(@"camera_d");
        cell.isHiddenSelectImg = YES;
    } else if (indexPath.item >= 1) {
        cell.isHiddenSelectImg = NO;
        cell.photoAsset = _dataArray[indexPath.item - 1];
        cell.selectCompletion = ^(id asset , BOOL hadSelectd, CPhotoGridCell *gridCell){
            [self didTapCellWithAsset: asset selectState: hadSelectd cell:gridCell];
        };
        
        NSString *photoUID = [CPhotoDataManager getAssetIdentifier: _dataArray[indexPath.item - 1]];
        
        NSMutableArray *tempArray = [NSMutableArray array];
        
        for (CPhotoAsset *asset in _selectedArray) { // 每次循环败笔 懒得改 恩 就是这么任性
            [tempArray addObject: asset.uniqueID];
        }
        
        if ([tempArray containsObject: photoUID]) {
            [cell selectCellItem: YES anim: NO];
            
        } else {
            [cell selectCellItem: NO anim: NO];
        }

    }
    return cell;
}

- (void)didTapCellWithAsset:(id)selectAsset selectState:(BOOL)selectState cell:(CPhotoGridCell *)cell {
    
    
    if (_maxSelectCount == 1) {
        [cell selectCellItem: YES anim: YES];
        self.selectedCompletion(@[selectAsset] , NO);
        [self cancelBtnClick];
        return;
    }
    
    CPhotoAsset *asset = [[CPhotoAsset alloc] init];
    asset.photoName = [CPhotoDataManager getImageNameFromAsset: selectAsset];
    asset.uniqueID = [CPhotoDataManager getAssetIdentifier: selectAsset];
    asset.photoAsset = selectAsset;
    
    NSInteger selectedIndex = -1;
    
    for (NSInteger i = 0; i < _selectedArray.count; i ++) {
        
        CPhotoAsset *photoAsset = _selectedArray[i];
        if ([photoAsset.uniqueID isEqualToString: asset.uniqueID]) {
            selectedIndex = i;
            break;
        }
    }
    
    if (selectedIndex == -1 && _selectedArray.count < _maxSelectCount) { // 没有命中
        
        [_selectedArray addObject: asset];
        [cell selectCellItem: YES anim: YES];
    } else {
        if (selectedIndex != -1) {
            [_selectedArray removeObjectAtIndex: selectedIndex];
            [cell selectCellItem: NO anim: YES];
        }
    }
    
    [self checkBtnState];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.item >= 1) {
        [self showBrowserVCWithDataArray: _dataArray selectIndex: indexPath.item - 1];
    } else if (indexPath.item == nil || indexPath.item == 0) {
        [self openCamera];
    }
    
//    id selectAsset = _dataArray[indexPath.item];
//    CPhotoGridCell * cell = (CPhotoGridCell *)[_listCollectionView cellForItemAtIndexPath: indexPath];
//
//    if (_maxSelectCount == 1) {
//        [cell selectCellItem: YES anim: YES];
//        self.selectedCompletion(@[selectAsset] , NO);
//        [self cancelBtnClick];
//        return;
//    }
//    
//    CPhotoAsset *asset = [[CPhotoAsset alloc] init];
//    asset.photoName = [CPhotoDataManager getImageNameFromAsset: selectAsset];
//    asset.uniqueID = [CPhotoDataManager getAssetIdentifier: selectAsset];
//    asset.photoAsset = selectAsset;
//    
//    NSInteger selectedIndex = -1;
//    
//    for (NSInteger i = 0; i < _selectedArray.count; i ++) {
//        
//        CPhotoAsset *photoAsset = _selectedArray[i];
//        if ([photoAsset.uniqueID isEqualToString: asset.uniqueID]) {
//            selectedIndex = i;
//            break;
//        }
//    }
//    
//    if (selectedIndex == -1 && _selectedArray.count < _maxSelectCount) { // 没有命中
//        
//        [_selectedArray addObject: asset];
//        [cell selectCellItem: YES anim: YES];
//    } else {
//        if (selectedIndex != -1) {
//            [_selectedArray removeObjectAtIndex: selectedIndex];
//            [cell selectCellItem: NO anim: YES];
//        }
//    }
//    
//    [self checkBtnState]; 
}

#pragma mark --- 拍照

- (void)openCamera {
    [CPhotoDataManager isCameraVisible:^(AVAuthorizationStatus status) {
        if (status == AVAuthorizationStatusRestricted || status == AVAuthorizationStatusDenied) {
            [SVProgressHUD showInfoWithStatus:kLimitCameraTips];
        } else {
            if (status == AVAuthorizationStatusNotDetermined) {
                [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                    if (granted == YES) {
                        [self pickerControllerFromSourceType:UIImagePickerControllerSourceTypeCamera];
                    }
                }];
            }else if (status == AVAuthorizationStatusAuthorized) {
                [self pickerControllerFromSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }
    }];
}
- (void)pickerControllerFromSourceType: (UIImagePickerControllerSourceType)sourceType {
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        NSLog(@"相机数据源无效");
        return ;
    }
    UIImagePickerController *pc = [[UIImagePickerController alloc] init];
    pc.view.backgroundColor = [UIColor blackColor];
    pc.allowsEditing = YES;
    pc.sourceType = sourceType;
    pc.delegate = self;
    pc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [self presentViewController:pc animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        self.selectedCompletion(@[image] , YES);
    }
    [picker dismissViewControllerAnimated: NO completion: nil];
    [self.presentingViewController dismissViewControllerAnimated: YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
