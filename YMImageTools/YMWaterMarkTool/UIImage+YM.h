
/**
 *  UIImage+YM.h
 */
#import <UIKit/UIKit.h>

@interface UIImage (YM)
/**
 *  打水印
 *
 *  @param backgroundImage   背景图片
 *  @param markName 右下角的水印图片
 */
+ (instancetype)waterMarkWithImageName:(UIImage *)backgroundImage imageStr:(NSString *)imageStr andMarkImageName:(NSString *)markName;
@end
