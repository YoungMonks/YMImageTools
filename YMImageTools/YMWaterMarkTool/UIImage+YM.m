
/**
 *  UIImage+YM.m
 */
#import "UIImage+YM.h"

@implementation UIImage (YM)

+ (instancetype)waterMarkWithImageName:(UIImage *)backgroundImage imageStr:(NSString *)imageStr andMarkImageName:(NSString *)markName{
    UIImage *bgImage;
    if (backgroundImage) {
        bgImage = backgroundImage;
    }else{
        bgImage = [UIImage imageNamed:imageStr];
    }
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
    UIImage *waterImage = [UIImage imageNamed:markName];
    CGFloat scale = 1;
    CGFloat margin = 5;
    CGFloat waterW = waterImage.size.width * scale;
    CGFloat waterH = waterImage.size.height * scale;
    CGFloat waterX = bgImage.size.width - waterW - margin;
    CGFloat waterY = bgImage.size.height - waterH - margin;
    
    [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
