//
//  CAlbumDropView.h
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/24.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CAlbumDropView : UIView

@property (nonatomic, copy) NSArray * _Nullable dataArray;

@property (nonatomic, copy) void(^ _Nonnull selecteHandler)(_Nullable id albumData);

@end
