//
//  CPickerHeader.h
//  LoginRegisterModule
//
//  Created by InitialC on 16/11/3.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#ifndef CPickerHeader_h

#define CPickerHeader_h
#ifdef __OBJC__

//#define CBaseUrl @"url"
#define WeakSelf(type)  __weak typeof(type) weak##type = type;

// 图片路径
/**
 @param kCImageSrcName(file) 为通过copy文件夹方式获取图片路径的宏
 @param kCImageFrameworkSrcName(file) 为通过cocoapods下载安装获取图片路径的宏
 @param kCLoginPageBundle 为获取xib/其它文件 Bundle路径
 @return 快速创建image
 */
#define kCGetBundle [NSBundle bundleForClass:[self class]]
#define kCImageSrcName(file) [@"CPickerSource.bundle" stringByAppendingPathComponent:file]
#define kCImageFrameworkSrcName(file) [@"Frameworks/CPhotoPicker.framework/CPickerSource.bundle" stringByAppendingPathComponent:file]
#define kCImageQuickName(file) [UIImage imageNamed:kCImageSrcName(file)?:kCImageFrameworkSrcName(file)]

#define kLimitPhotoTips @"请进入设置 -> 嫣汐 -> 打开照片选项"
#define kLimitCameraTips @"请进入设置 -> 嫣汐 -> 打开相机选项"

#define CFunc  NSLog(@"%s",__func__);
//DEBUG  模式下打印日志,当前行 并弹出一个警告
#ifdef DEBUG
#   define ZLog(fmt, ...)  { UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%s\n [Line %d] ", __PRETTY_FUNCTION__, __LINE__] message:[NSString stringWithFormat:fmt, ##__VA_ARGS__]  delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil]; [alert show]; }
#else
#   define ZLog(...)
#endif

#import <SVProgressHUD/SVProgressHUD.h>

#endif

#endif /* CPickerHeader_h */

