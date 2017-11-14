//
//  YMImagePickerController.m
//  pushImage
//
//  Created by 张江威 on 2017/11/10.
//  Copyright © 2017年 YoungMonk. All rights reserved.
//

#import "YMImagePickerController.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "UIImage+Common.h"
#import "UIImage+YM.h"
@interface YMImagePickerController ()<UIImagePickerControllerDelegate,UIActionSheetDelegate, UINavigationControllerDelegate>

@end

@implementation YMImagePickerController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _thread = [[NSThread alloc] initWithTarget:self selector:@selector(initImgPicker) object:nil];
    [_thread start];
    self.view.backgroundColor = [UIColor clearColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initImgPicker{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    //判断是否有摄像头
    if(![UIImagePickerController isSourceTypeAvailable:sourceType])
    {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    _pickerCamera=[[UIImagePickerController alloc]init];
    _pickerCamera.sourceType=sourceType;
    _pickerCamera.delegate=self;
    _pickerCamera.allowsEditing=NO;
    
    _PickerImage=[[UIImagePickerController alloc]init];
    _PickerImage.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    _PickerImage.delegate=self;
    _PickerImage.allowsEditing=NO;
    
    
}


//上传图片事件
- (void)uploadClick
{
    //    self.myImage = (UIImageView *)sender.view;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从相册中选择", nil];
    [actionSheet showInView:self.view];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self dismissViewController];
}

//退出当前视图
-(void)dismissViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UIActionSheet delegate

//设置sheetButtonAction
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0)
    {
        if ([self canUseCamera]) {
            //判断设备是否有摄像头
            if ([self validateCamera])
            {
                
                if ([_thread isFinished]) {
                    [self presentViewController:_pickerCamera animated:YES completion:NULL];
                    
                }
            } else {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"友情提示" message:@"该设备没有摄像头" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles:nil, nil];
                [alert show];
                [self dismissViewController];
            }
        }
    }
    else if (buttonIndex==1)
    {
        
        if ([_thread isFinished]) {
            [self presentViewController:_PickerImage animated:YES completion:nil];
        }
        
    }
    
}

#pragma mark - UIImagePickerdelegate

//六、实现ImagePicker delegate 事件
//选取图片
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewController];
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    
    UIImage *originalImage;
    if (CFStringCompare((CFStringRef) mediaType,kUTTypeImage, 0)== kCFCompareEqualTo) {
        originalImage = (UIImage *) [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    if (picker==_pickerCamera)
    {
        //将图片保存到相册
        UIImageWriteToSavedPhotosAlbum(originalImage, self, nil, nil);
    }
    //    保存到本地
    _data = [[originalImage YM_normalizedImage]YM_dataCompress];//图片压缩
    self.myImage.image = [UIImage imageWithData:_data];
    
    //    image转换为字符串
    NSData*         data=UIImageJPEGRepresentation([UIImage imageWithData:_data], 0.00000001);
    _imageStr= [data base64EncodedStringWithOptions:0];
    [self.delegate YMImagePickerData:data imageStr:_imageStr image:[UIImage imageWithData:_data]];
    [self dismissViewController];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)canUseCamera {
    
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied ){//|| authStatus == AVAuthorizationStatusNotDetermined || authStatus == AVAuthorizationStatusAuthorized
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请在设备的设置-隐私-相机中允许访问相机。" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        return NO;
    }
    
    return YES;
}

-(BOOL)validateCamera {
    
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] &&
    [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

@end
