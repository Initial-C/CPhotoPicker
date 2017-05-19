//
//  CPhotoGridCell.h
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/18.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPhotoGridCell : UICollectionViewCell

@property (nonatomic, strong) id photoAsset;

@property (nonatomic, assign) BOOL isHiddenSelectImg;

@property (nonatomic, copy) void(^selectCompletion)(id asset , BOOL hadSelected ,CPhotoGridCell*);

- (void)resetSelectState;

- (void)selectCellItem:(BOOL)select anim:(BOOL)anim;



@end
