//
//  UIView+Addition.m
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/24.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)
- (void)setC_x:(CGFloat)c_x {
    CGRect frame = self.frame;
    frame.origin.x = c_x;
    self.frame = frame;
}
- (CGFloat)c_x {
    return self.frame.origin.x;
}

- (void)setC_y:(CGFloat)c_y {
    CGRect frame = self.frame;
    frame.origin.y = c_y;
    self.frame = frame;
}
- (CGFloat)c_y
{
    return self.frame.origin.y;
}

- (void)setC_centerX:(CGFloat)c_centerX {
    CGPoint center = self.center;
    center.x = c_centerX;
    self.center = center;
}
- (CGFloat)c_centerX {
    return self.center.x;
}

- (void)setC_centerY:(CGFloat)c_centerY {
    CGPoint center = self.center;
    center.y = c_centerY;
    self.center = center;
}
-(CGFloat)c_centerY {
    return self.center.y;
}

- (void)setC_width:(CGFloat)c_width {
    CGRect frame = self.frame;
    frame.size.width = c_width;
    self.frame = frame;
}
- (CGFloat)c_width {
    return self.bounds.size.width;
}

- (void)setC_height:(CGFloat)c_height {
    CGRect frame = self.frame;
    frame.size.height = c_height;
    self.frame = frame;
}
- (CGFloat)c_height {
    return self.frame.size.height;
}

- (void)setC_size:(CGSize)c_size {
    CGRect frame = self.frame;
    frame.size = c_size;
    self.frame = frame;
}
- (CGSize)c_size {
    return self.frame.size;
}

- (CGFloat)c_maxX {
    return self.frame.origin.x + self.frame.size.width;
}
- (CGFloat)c_maxY {
    return self.frame.origin.y + self.frame.size.height;
}

@end
