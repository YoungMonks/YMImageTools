//
//  UIImage+YPExtension.h
//  Wuxianda
//
//  Created by MichaelPPP on 16/1/21.
//  Copyright © 2016年 michaelhuyp. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Common)

///  压缩图片至500k以下
///  @return 压缩完成二进制
-(NSData *)YM_dataCompress;

///  处理直接拍照上传照片 图片翻转的问题
///  @return 经过处理完成的 image
-(UIImage *)YM_normalizedImage;


/**
 根据当前图片宽度 返回一张可以随意拉伸但不变形的图片
 */
-(UIImage *)YM_resizedImage;


///  获取指定大小图片
///  @param asize size
///  @return 返回 处理结果
- (UIImage *)YM_thumbnailWithSize:(CGSize)asize;

///  裁剪图片 Rect
///  @param rect 裁剪的范围
///  @return 返回处理结果
-(UIImage *)YM_clipImageInRect:(CGRect )rect;

///  改变图像的尺寸，方便上传服务器
///  @param size 需要改变尺寸大小
///  @return 返回处理结果
-(UIImage *)YM_scaleToSize:(CGSize)size;

/**
 图片指定size 进行比例缩放

 @param size 目标size

 @return 返回截取结果 image
 */
-(UIImage *)YM_imageCompressToTagetSize:(CGSize)size;


/**
 图片指定宽度 进行比例缩放

 @param defineWidth 目标width

 @return 返回截取结果 image
 */
-(UIImage *)YM_imageCompressToTagetWidth:(CGFloat)defineWidth;





/** 压缩 */
- (UIImage *)yp_scaleToSize:(CGSize)size;

/** 等比例压缩 */
- (UIImage *)yp_imageCompressForSize:(CGSize)size;

/**
 *  返回指定尺寸的图片
 */
- (UIImage *)yp_imageWithScaleSize:(CGSize)scaleSize;

/**
 *  返回拉伸后的图片,默认为从中点拉伸
 */
+ (UIImage *)yp_resizeImageWithName:(NSString *)imageName;

/**
 *  返回拉伸后的图片,指定拉伸位置
 */
+ (UIImage *)yp_resizeImageWithName:(NSString *)imageName edgeInsets:(UIEdgeInsets)edgeInset;

/**
 *  将方图片转换成圆图片
 */
+ (UIImage *)yp_circleImageWithOldImage:(UIImage *)oldImage borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

+ (UIImage *)yp_generateCenterImageWithBgColor:(UIColor *)bgImageColor bgImageSize:(CGSize)bgImageSize centerImage:(UIImage *)centerImage;
- (NSData *)dataSmallerThan:(NSUInteger)dataLength;
- (NSData *)dataForCodingUpload;


- (UIImage *)YM_cutImageView:(UIImageView *)imageView;


/** 取消searchBar背景色 */
+ (UIImage *)searchBarBackgroundWithColor:(UIColor *)color size:(CGSize)size;


-(UIImage *)YM_compressImage;
@end
