//
//  CPhotoPicker.h
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/18.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CPhotoPicker : NSObject

@property (strong, nonatomic) NSString *limitPhotoTips;
@property (strong, nonatomic) NSString *limitCameraTips;

- (void)showPhotoPickerWithController:(UIViewController *)controller maxSelectCount:(NSUInteger)maxCount completion:(void (^)(NSArray *imageSources , BOOL isImgType))completion;

@end
