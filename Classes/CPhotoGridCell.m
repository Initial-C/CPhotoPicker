//
//  CPhotoGridCell.m
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/18.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import "CPhotoGridCell.h"
#import "CPhotoDataManager.h"
#import "CPhotoGridViewController.h"
#import "UIView+Addition.h"
#import "CPickerHeader.h"

@implementation CPhotoGridCell{
    UIImageView *_thumbImgView;
    BOOL _hadSelected;
    UIImageView * _selectIconImgView;
    UIImageView *_cameraImgView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame: frame];
    if (self) {
        _hadSelected = NO;
        _thumbImgView = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, PhotoCellWidth, PhotoCellWidth)];
        [self.contentView addSubview: _thumbImgView];
        _thumbImgView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImgView.clipsToBounds = YES;
        
        _selectIconImgView = [[UIImageView alloc] initWithFrame: CGRectMake(self.contentView.width - 27, 0, 27, 27)];
        [self.contentView addSubview: _selectIconImgView];
        _selectIconImgView.image = kCImageQuickName(@"gridCell_unSelect");
        _selectIconImgView.userInteractionEnabled = YES;
        
        [_selectIconImgView addGestureRecognizer: [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(tapSelectIcon)]];
        
        CGFloat cameraXY = (self.contentView.width - 50) * 0.5;
        _cameraImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cameraXY, cameraXY, 50, 50)];
        _cameraImgView.backgroundColor = [UIColor clearColor];
        _cameraImgView.userInteractionEnabled = YES;
        [self.contentView addSubview:_cameraImgView];
        
    }
    return self;
}

- (void)tapSelectIcon {
    _hadSelected = !_hadSelected;
//    
//    if (_hadSelected) {
//        _selectIconImgView.image = [UIImage imageNamed: @"gridCell_select"];
//        if (1) {
//            [self showSelectAnimationWithLayer: _selectIconImgView.layer isBig: YES];
//        }
//    } else {
//        _selectIconImgView.image = [UIImage imageNamed: @"gridCell_unSelect"];
//        if (1) {
//            [self showSelectAnimationWithLayer: _selectIconImgView.layer isBig: NO];
//        }
//    }
    self.selectCompletion(_photoAsset , _hadSelected, self);
}

- (void)setSelected:(BOOL)selected {
    [super setSelected: selected];
    
}

- (void)resetSelectState {
    _selectIconImgView.image = kCImageQuickName(@"gridCell_unSelect");
    [_selectIconImgView.layer removeAllAnimations];
}

- (void)setIsHiddenSelectImg:(BOOL)isHiddenSelectImg {
    if (isHiddenSelectImg) {
        _selectIconImgView.hidden = YES;
    } else {
        _selectIconImgView.hidden = NO;
    }
}

- (void)selectCellItem:(BOOL)select anim:(BOOL)anim{
    
    if (select) {
        _selectIconImgView.image = kCImageQuickName(@"gridCell_select");
        if (anim) {
            [self showSelectAnimationWithLayer: _selectIconImgView.layer isBig: YES];
        }
    } else {
        _selectIconImgView.image = kCImageQuickName(@"gridCell_unSelect");
        if (anim) {
            [self showSelectAnimationWithLayer: _selectIconImgView.layer isBig: NO];
        }
    }
}

- (void)showSelectAnimationWithLayer:(CALayer *)layer isBig:(BOOL)isBig{
    NSNumber *animationScale1 = isBig ? @(1.15) : @(0.5);
    NSNumber *animationScale2 = isBig ? @(0.92) : @(1.15);
    
    [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
        [layer setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [layer setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.05 delay:0 options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
                [layer setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

- (void)setPhotoAsset:(id)photoAsset {
    if ([photoAsset isKindOfClass:[UIImage class]]) {
        _thumbImgView.hidden = YES;
        _cameraImgView.hidden = NO;
        _selectIconImgView.hidden = YES;
        _cameraImgView.image = photoAsset;
        return;
    }
    _thumbImgView.hidden = NO;
    _cameraImgView.hidden = YES;
    _selectIconImgView.hidden = NO;
    _photoAsset = photoAsset;
    
    [[CPhotoDataManager shareInstance] fetchImageFromAsset: photoAsset type: ePhotoResolutionTypeThumb targetSize: CGSizeMake(PhotoCellWidth,PhotoCellWidth) result:^(UIImage * img) {
        
        _thumbImgView.image = img;
    }];
    
}


@end
