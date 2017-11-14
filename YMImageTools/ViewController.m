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
#import "YMPhotosManager.h"
#import "SQBannarView.h"


@interface ViewController ()<YMImagePickerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *bagImage;
@property (weak, nonatomic) IBOutlet UIImageView *logoImage;

@property (strong, nonatomic) UIImageView * banImage;
@property (strong, nonatomic) NSMutableArray *images;
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) YMImagePickerController * imageController;
@property (strong, nonatomic) SQBannarView *bannerView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _banImage = [[UIImageView alloc]init];
    self.bagImage.userInteractionEnabled = YES;
    UITapGestureRecognizer * singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upClick:)];
    [self.bagImage addGestureRecognizer:singleTap];
    
    self.logoImage.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [self.logoImage addGestureRecognizer:tap];
    [self imageBander];
}
-(void) imageBander{
    _imageViews = @[].mutableCopy;
    _images = @[].mutableCopy;
    UIImageView *images = [[UIImageView alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"YoungMonk.png"]]];
    [_imageViews addObject:images];
    [_images addObject:images.image];
    
    _bannerView = [[SQBannarView alloc]initWithFrame:CGRectMake((self.view.frame.size.width-150)/2, self.view.frame.size.height/2+100, 150, 150) viewSize:CGSizeMake(150,150)];
    _bannerView.isTimer = YES;//定时器是否开启
    _bannerView.items = _images;
    [self.view addSubview:_bannerView];
    [_bannerView imageViewClick:^(SQBannarView * _Nonnull barnerview, NSInteger index) {
        [[YMPhotosManager sharedManager]showPhotosWithfromViews:_imageViews images:_images imageUrls:nil index:index];
    }];
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
    _banImage.image = image;
    //添加背景图
    self.bagImage.image = image;
    
    //添加轮播图
    [_imageViews addObject:_banImage];
    [_images addObject:image];
    _bannerView.items = _images;
    
    //添加logo
    _logoImage.image = [UIImage waterMarkWithImageName:image imageStr:nil andMarkImageName:@"logo"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
