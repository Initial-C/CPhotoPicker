//
//  UIView+Addition.h
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/24.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

@property (nonatomic, assign) CGFloat c_x;
@property (nonatomic, assign) CGFloat c_y;
@property (nonatomic, assign) CGFloat c_centerX;
@property (nonatomic, assign) CGFloat c_centerY;
@property (nonatomic, assign) CGFloat c_width;
@property (nonatomic, assign) CGFloat c_height;
@property (nonatomic, assign) CGSize c_size;
@property (nonatomic, assign, readonly) CGFloat c_maxX;
@property (nonatomic, assign, readonly) CGFloat c_maxY;

@end
