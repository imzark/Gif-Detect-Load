//
//  gifDisplayViewController.m
//  GifDetectAndLoad
//
//  Created by Zark on 2017/8/3.
//  Copyright © 2017年 Zarky. All rights reserved.
//

#import "gifDisplayViewController.h"
#import <ImageIO/ImageIO.h>

@interface gifDisplayViewController ()

@property (nonatomic, strong) UIImageView *gifImageView;
@property (nonatomic, strong) NSMutableArray *gifFramesArr;

@end

@implementation gifDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.gifImageView];
    self.gifImageView.animationImages = self.gifFramesArr;
    self.gifImageView.animationDuration = 3;
    [self.gifImageView startAnimating];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

#pragma mark - Setters & Getters

- (UIImageView *)gifImageView {
    if (!_gifImageView) {
        _gifImageView = ({
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 300, 300)];
            imageView.center = self.view.center;
            imageView.backgroundColor = [UIColor clearColor];
            imageView;
        });
    }
    return _gifImageView;
}

- (NSMutableArray *)gifFramesArr {
    if (!self.gifData) {
        NSLog(@"No Gif Data");
        return [NSMutableArray array];
    }
    if (!_gifFramesArr) {
    
        CGImageSourceRef gifSource = CGImageSourceCreateWithData((CFDataRef)self.gifData, NULL);
        size_t frameCout=CGImageSourceGetCount(gifSource);//获取其中图片源个数，即由多少帧图片组成
        NSMutableArray* frames=[[NSMutableArray alloc] init];//定义数组存储拆分出来的图片
        for (size_t i=0; i < frameCout; i++){
            CGImageRef imageRef=CGImageSourceCreateImageAtIndex(gifSource, i, NULL);//从GIF图片中取出源图片
            UIImage* imageName=[UIImage imageWithCGImage:imageRef];//将图片源转换成UIimageView能使用的图片源
            [frames addObject:imageName];//将图片加入数组中
            CGImageRelease(imageRef);
        }
        _gifFramesArr = [frames mutableCopy];
    }
    return _gifFramesArr;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
