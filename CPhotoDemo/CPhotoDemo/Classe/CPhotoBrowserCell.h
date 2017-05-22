//
//  CPhotoBrowserCell.h
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/20.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CPhotoBrowserCell : UICollectionViewCell

@property (nonatomic, strong) id photoAsset;

- (void)resetUI;

@end
