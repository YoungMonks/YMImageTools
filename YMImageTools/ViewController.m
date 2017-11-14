//
//  ViewController.m
//  pushImage
//
//  Created by 张江威 on 2017/11/10.
//  Copyright © 2017年 YoungMonk. All rights reserved.
//

#import "ViewController.h"
#import "YMImagePickerController.h"
#import "UIImage+YM.h"
#import "YMAvatarBrowser.h"

@interface ViewController ()<YMImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bagImage;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (strong, nonatomic) YMImagePickerController * imageController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor yellowColor];
    self.bagImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upClick:)];
    [self.bagImage addGestureRecognizer:singleTap];
    
    self.logoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.logoImage addGestureRecognizer:tap];
}
//放大展示
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    [YMAvatarBrowser showImage:self.logoImage];
}
//上传图片事件
- (void)upClick:(UITapGestureRecognizer *)sender{
    _imageController=[[YMImagePickerController alloc]init];
    _imageController.delegate = self;
    [self addChildViewController:_imageController];
    [_imageController uploadClick];

}
//回调图片
- (void)YMImagePickerData:(NSData *)imageData imageStr:(NSString *)imageStr image:(UIImage *)image{
    self.bagImage.image = image;
    _logoImage.image = [UIImage waterMarkWithImageName:image imageStr:nil andMarkImageName:@"logo"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
