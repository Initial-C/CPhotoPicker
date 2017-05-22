//
//  CAlbumListViewController.h
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/18.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const _Nonnull AlbumListCellIdentifier;

@interface CAlbumListViewController : UIViewController

@property (nonatomic , copy) void (^_Nonnull selectCompletion)(id _Nonnull albumData);

@end
