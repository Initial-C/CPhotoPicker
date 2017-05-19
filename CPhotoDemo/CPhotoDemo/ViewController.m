//
//  ViewController.m
//  CPhotoDemo
//
//  Created by InitialC on 2017/5/19.
//  Copyright © 2017年 InitialC. All rights reserved.
//

#import "ViewController.h"
#import <CPhotoPicker.h>
#import <CPhotoDataManager.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *pickerBtn;
@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.pickerBtn.layer.cornerRadius = 12;
    self.pickerBtn.layer.masksToBounds = YES;
    
}
- (IBAction)pickerClick:(id)sender {
    CPhotoPicker *picker = [[CPhotoPicker alloc] init];
    __weak typeof(self) weakSelf = self;
    [picker showPhotoPickerWithController:self maxSelectCount:6 completion:^(NSArray *imageSources, BOOL isImgType) {
        if (isImgType) {
            NSLog(@"图片UIImage数据结果(照相机照的)==%@", imageSources);
        } else {
            NSLog(@"照片资源数据结果(相册多选的)==%@", imageSources);
            for (id image in imageSources) {
                [[CPhotoDataManager shareInstance] fetchImageFromAsset:image type:ePhotoResolutionTypeScreenSize targetSize:[UIScreen mainScreen].bounds.size result:^(UIImage *image) {
                    NSLog(@"单张图==%@", image);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        weakSelf.imageV.image = image;
                    });
                }];
            }
        }
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
