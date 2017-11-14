//
//  YMImagePickerController.h
//  pushImage
//
//  Created by 张江威 on 2017/11/10.
//  Copyright © 2017年 YoungMonk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol YMImagePickerDelegate <NSObject>

- (void)YMImagePickerData:(NSData *)imageData imageStr:(NSString *)imageStr image:(UIImage *)image;

@end

@interface YMImagePickerController : UIViewController

@property (nonatomic, weak) id<YMImagePickerDelegate>delegate;


@property (strong, nonatomic) NSData *data;

@property (strong,nonatomic) NSString*  imageStr;

@property (nonatomic,strong) UIImagePickerController * pickerCamera;
@property (nonatomic,strong) UIImagePickerController * PickerImage;
@property (strong,nonatomic) NSString * pickerStr;
@property (nonatomic) NSThread *thread;
@property (nonatomic, strong) UIImageView *myImage;

//上传图片事件
- (void)uploadClick;

@end
