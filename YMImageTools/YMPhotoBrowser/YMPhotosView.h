//
//  YMPhotosView.h
//  pushImage
//
//  Created by 张江威 on 2017/11/10.
//  Copyright © 2017年 YoungMonk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SQPhotoItem : NSObject

@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, strong) NSURL *largeImageURL;


@end




@interface YMPhotosView : UIView

- (instancetype)init UNAVAILABLE_ATTRIBUTE;//这方法不能调用
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithPhotoItems:(NSArray<SQPhotoItem *>*) photoItems;

- (void)showViewFromIndex:(NSInteger)index;

@end
