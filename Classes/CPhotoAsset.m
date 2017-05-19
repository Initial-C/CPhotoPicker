//
//  CPhotoAsset.m
//  CPhotoPickerDemo
//
//  Created by InitialC on 2016/10/20.
//  Copyright © 2016年 InitialC. All rights reserved.
//

#import "CPhotoAsset.h"

@implementation CPhotoAsset

- (NSString *)description {
    return [NSString stringWithFormat: @"PhotoAssetModel - photoName:%@ ，UID:%@",_photoName, _uniqueID];
}

@end
