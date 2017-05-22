//
//  CPhotoBrowserViewController.h
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/20.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPhotoBrowserViewController : UIViewController

@property (nonatomic, assign) NSUInteger maxSelectCount;

@property (nonatomic, copy) NSArray *dataArray;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSMutableArray *selecteAssets; // [CPhotoAsset]

@property (nonatomic, copy) void (^onSelectedPhotos)(NSArray *); // [CPhotoAsset]

@property (nonatomic, copy) void (^onCommitPhotos)(NSArray *); // [CPhotoAsset]

@end
 
