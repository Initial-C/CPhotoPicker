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
    /*
     finalShareImgUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false).appendingPathComponent("memoryForWeChat.jpeg")
     do {
     try UIImageJPEGRepresentation(finalShareImg!, 0.8)?.write(to: finalShareImgUrl!, options: .atomic)
     } catch {
     print("writingImageDataError==\(error)")
     }
     */
    CPhotoPicker *picker = [[CPhotoPicker alloc] init];
    __weak typeof(self) weakSelf = self;
    [picker showPhotoPickerWithController:self maxSelectCount:6 completion:^(NSArray *imageSources, BOOL isImgType) {
        if (isImgType) {
//            NSLog(@"图片UIImage数据结果(照相机照的)==%@", imageSources);
        } else {
//            NSLog(@"照片资源数据结果(相册多选的)==%@", imageSources);
            for (id image in imageSources) {
                [[CPhotoDataManager shareInstance] fetchImageFromAsset:image type:ePhotoResolutionTypeOrigin targetSize:[UIScreen mainScreen].bounds.size result:^(UIImage *image) {
                    image = [weakSelf resizeImage:image];
                    NSLog(@"单张图==%@", image);
                    weakSelf.imageV.image = image;
                }];
            }
        }
    }];
}
- (UIImage *)resizeImage:(UIImage *)oriImage {
    // 并把它设置成为当前正在使用的context
    CGSize newSize = oriImage.size;
    if (newSize.width > 0 && newSize.width < 750) {
        return oriImage;
    } else {
        newSize = CGSizeMake(750, newSize.height * 750 / newSize.width);
    }
    UIGraphicsBeginImageContext(newSize);
    
    // 绘制改变大小的图片
    
    [oriImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    // 从当前context中创建一个改变大小后的图片
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    
    return scaledImage;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
