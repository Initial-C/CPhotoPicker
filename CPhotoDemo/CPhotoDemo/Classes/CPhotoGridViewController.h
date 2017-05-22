//
//  CPhotoGridViewController.h
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/18.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PhotoCellWidth (([UIScreen mainScreen].bounds.size.width - 5 * 5) / 4)

@interface CPhotoGridViewController : UIViewController

@property (nonatomic , assign) NSUInteger maxSelectCount;

@property (nonatomic , strong) id albumData; // 配合CAlbumListViewController

@property (nonatomic , copy) void (^selectedCompletion)(NSArray * imagesArray, BOOL isImgType);

@end
