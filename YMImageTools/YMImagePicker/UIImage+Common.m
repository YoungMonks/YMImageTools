//
//  UIImage+YPExtension.m
//  Wuxianda
//
//  Created by MichaelPPP on 16/1/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import "UIImage+Common.h"
#import <CoreGraphics/CoreGraphics.h>

@implementation UIImage (YPExtension)





//压缩图片至500k以下
-(NSData *)YM_dataCompress
{
    NSData *data=UIImageJPEGRepresentation(self, 1.0);

    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(self, 0.5);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(self, 1.0);
        }else if (data.length>200*1024) {//0.25M-0.5M
            data=UIImageJPEGRepresentation(self, 1.0);
        }
    }


    return data;
}

///处理直接拍照上传照片 图片翻转的问题
-(UIImage *)YM_normalizedImage{
    if (self.imageOrientation == UIImageOrientationUp)return self;

    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    [self drawInRect:(CGRect){0,0,self.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;

}

/**
 根据当前图片宽度 返回一张可以随意拉伸但不变形的图片
 */
-(UIImage *)YM_resizedImage{
    CGFloat W = self.size.width * 0.5;
    CGFloat H = self.size.height * 0.5;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(H, W, H, W)];
}

///  获取指定大小图片
///  @param asize size
///  @return 返回 处理结果
- (UIImage *)YM_thumbnailWithSize:(CGSize)asize{
    UIImage *newImage;
    if (self == nil) {
        newImage = nil;
    }else{
        CGSize oldSize = self.size;
        CGRect rect;
        if (asize.width / asize.height > oldSize.width/oldSize.height) {
            rect.size.width = asize.height * oldSize.width / oldSize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width) / 2;
            rect.origin.y = 0;
        }else{
            rect.size.width = asize.width;
            rect.size.height = asize.width * oldSize.height / oldSize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height) / 2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [self drawInRect:rect];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }

    return newImage;

}

///  裁剪图片 Rect
///  @param rect 裁剪的范围
///  @return 返回处理结果
-(UIImage *)YM_clipImageInRect:(CGRect )rect{
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *subImage = [UIImage imageWithCGImage:imageRef];
    return subImage;
}


///  改变图像的尺寸，方便上传服务器
///  @param size 需要改变尺寸大小
///  @return 返回处理结果
-(UIImage *)YM_scaleToSize:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
//    UIGraphicsBeginImageContext(size);
    [self drawInRect:(CGRect){0,0,size}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


/**
 图片指定size 进行比例缩放

 @param size 目标size

 @return 返回截取结果 image
 */
-(UIImage *)YM_imageCompressToTagetSize:(CGSize)size{

    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWith = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetWidth / height;

        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWith = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWith) * 0.5;
        }
    }

    //打开图片上下文
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWith;
    thumbnailRect.size.height = scaledHeight;
    //用计算好的 rect 进行图片裁剪
    [self drawInRect:thumbnailRect];
    //获取 当前截取好的上下文
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
    }

    UIGraphicsEndImageContext();

    return newImage;
}


/**
 图片指定宽度 进行比例缩放

 @param defineWidth 目标width

 @return 返回截取结果 image
 */
-(UIImage *)YM_imageCompressToTagetWidth:(CGFloat)defineWidth{

    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if (CGSizeEqualToSize(imageSize, size) == NO) {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if (widthFactor > heightFactor) {
            scaleFactor = widthFactor;
        }else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        if (widthFactor > heightFactor) {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if (widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    //打开上下文
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    //计算好的 rect 进行图片裁剪
    [self drawInRect:thumbnailRect];
    //获取图片上下文
    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if (newImage == nil) {
    }
    //关闭上下文
    UIGraphicsEndImageContext();

    return newImage;
}





- (UIImage *)yp_scaleToSize:(CGSize)size
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(0,0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    //返回新的改变大小后的图片
    return scaledImage;
}

- (UIImage *)yp_imageCompressForSize:(CGSize)size
{
    UIImage *newImage = nil;
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = size.width;
    CGFloat targetHeight = size.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    [self drawInRect:thumbnailRect];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
    }
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

/**
 *  返回指定尺寸的图片
 */
- (UIImage *)yp_imageWithScaleSize:(CGSize)scaleSize {
    
    UIGraphicsBeginImageContext(scaleSize);
    
    // 指定图片尺寸
    [self drawInRect:(CGRect){CGPointZero,scaleSize}];
    
    // 获取指定尺寸的图片
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [scaleImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
}


- (UIImage *)YM_cutImageView:(UIImageView *)imageView{
    //压缩图片
    CGSize newSize;
    CGImageRef imageRef = nil;
    
    if ((self.size.width / self.size.height) < (imageView.frame.size.width / imageView.frame.size.height))
    {
        newSize.width = self.size.width;
        
        newSize.height = self.size.width * imageView.frame.size.height / imageView.frame.size.width;
        
        imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(0, fabs(self.size.height - newSize.height) / 2, newSize.width, newSize.height));
        
    } else
    {
        newSize.height = self.size.height;
        
        newSize.width = self.size.height * imageView.frame.size.width / imageView.frame.size.height;
        
        imageRef = CGImageCreateWithImageInRect([self CGImage], CGRectMake(fabs(self.size.width - newSize.width) / 2, 0, newSize.width, newSize.height));
    }
    return [UIImage imageWithCGImage:imageRef];
}

/**
 *  返回拉伸后的图片,默认为从中点拉伸
 */
+ (UIImage *)yp_resizeImageWithName:(NSString *)imageName {
    return [self yp_resizeImageWithName:imageName edgeInsets:UIEdgeInsetsZero];
}

/**
 *  返回拉伸后的图片,指定拉伸位置
 */
+ (UIImage *)yp_resizeImageWithName:(NSString *)imageName edgeInsets:(UIEdgeInsets)edgeInsets {
    
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    return image;
}



/**
 *  将方图片转换成圆图片
 */
+ (UIImage *)yp_circleImageWithOldImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    // 1.开启上下文
    CGFloat border = borderWidth;
    CGFloat imageW = oldImage.size.width + 2 * border;
    CGFloat imageH = oldImage.size.height + 2 * border;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    // 2.取出当前上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 3.画边框(大圆)
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    // 小圆
    CGFloat smallRadius = bigRadius - border;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, 2 * M_PI, 0);
    CGContextClip(ctx);
    
    // 画图
    [oldImage drawInRect:CGRectMake(border, border, oldImage.size.width, oldImage.size.height)];
    
    // 取图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //结束上下文
    UIGraphicsEndImageContext();
    
    return image;
    
}

+ (UIImage *)yp_generateCenterImageWithBgColor:(UIColor *)bgImageColor bgImageSize:(CGSize)bgImageSize centerImage:(UIImage *)centerImage
{
    UIImage *bgImage = [UIImage imageWithColor:bgImageColor size:bgImageSize];
    UIGraphicsBeginImageContext(bgImage.size);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    [centerImage drawInRect:CGRectMake((bgImage.size.width - centerImage.size.width) * 0.5, (bgImage.size.height - centerImage.size.height) * 0.5, centerImage.size.width, centerImage.size.height)];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    if (!color || size.width <= 0 || size.height <= 0) return nil;
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (NSData *)dataSmallerThan:(NSUInteger)dataLength{
    NSData *data = UIImageJPEGRepresentation(self, 1.0);
    while (data.length > dataLength) {
        UIImage *image = [UIImage imageWithData:data];
        data = UIImageJPEGRepresentation(image, 0.7);
    }
    return data;
}
- (NSData *)dataForCodingUpload{
    return [self dataSmallerThan:1024 * 1000];
}


/** 取消searchBar背景色 */
- (UIImage *)searchBarBackgroundWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}


-(UIImage *)YM_compressImage
{
    float imageWidth = self.size.width;
    float imageHeight = self.size.height;
    float width = 640;
    float height = self.size.height/(self.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [self drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [self drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@end
