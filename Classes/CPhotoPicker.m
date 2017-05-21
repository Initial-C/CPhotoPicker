//
//  CPhotoPicker.m
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/18.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import "CPhotoPicker.h"
#import "CPhotoDataManager.h"
#import "CAlbumListViewController.h"
#import "CPhotoGridViewController.h"
#import "CPickerHeader.h"

@implementation CPhotoPicker

- (void)showPhotoPickerWithController:(id)controller maxSelectCount:(NSUInteger)maxCount completion:(void (^)(NSArray *,BOOL))completion {
    
    [CPhotoDataManager isPhotoLibraryVisible:^(PhotoAuthorizationStatus status) {
        
        if (status == PhotoAuthorizationStatusDenied) {
            
            [SVProgressHUD showInfoWithStatus:kLimitPhotoTips];
            
        }else if(status == PhotoAuthorizationStatusNotDetermined){
            //相册进行授权
            /* * * 第一次安装应用时直接进行这个判断进行授权 * * */
            
            [CPhotoDataManager requestAuthorization:^(PhotoAuthorizationStatus authorStatus) {
                
                if (authorStatus == PhotoAuthorizationStatusAuthorized) {
                    [self showPhotoListVCWithController: controller maxSelectCount: maxCount completion: completion];
                }
            }];
            
        }else if (status == PhotoAuthorizationStatusAuthorized){
            
            [self showPhotoListVCWithController: controller maxSelectCount: maxCount completion: completion];
        }
    }];
}

- (void)showPhotoListVCWithController:(UIViewController *)controller  maxSelectCount:(NSUInteger)maxCount completion:(void (^)(NSArray * , BOOL isImgType))completion {
//    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
//
//        CAlbumListViewController * albumListVC = [[CAlbumListViewController alloc] init];
//        UINavigationController * listNav = [[UINavigationController alloc] initWithRootViewController: albumListVC];
//        [controller presentViewController: listNav animated: YES completion: nil];
//
//        albumListVC.selectCompletion = ^(id albumData) {
//
//            CPhotoGridViewController * photoListVC = [[CPhotoGridViewController alloc] init];
//            photoListVC.maxSelectCount = maxCount;
//            photoListVC.albumData = albumData;
//            photoListVC.selectedCompletion = ^ (NSArray * imagesArray) {
//
//                if (completion) {
//                    completion(imagesArray);
//                }
//            };
//
//            [listNav pushViewController: photoListVC animated: YES];
//        };
//
//        CPhotoGridViewController * photoListVC = [[CPhotoGridViewController alloc] init];
//        photoListVC.maxSelectCount = maxCount;
//        photoListVC.selectedCompletion = ^ (NSArray * imagesArray) {
//
//            if (completion) {
//                completion(imagesArray);
//            }
//        };
//
//        [listNav pushViewController: photoListVC animated: NO];
//    });
        CPhotoGridViewController * photoListVC = [[CPhotoGridViewController alloc] init];
        UINavigationController * listNav = [[UINavigationController alloc] initWithRootViewController: photoListVC];
        photoListVC.maxSelectCount = maxCount;
        photoListVC.selectedCompletion = ^ (NSArray * imagesArray, BOOL isImgType) {
            if (completion) {
                completion(imagesArray , isImgType);
            }
        };
        [controller presentViewController: listNav animated: YES completion: nil];
    });
}

@end
