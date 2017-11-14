//
//  YMPhotosManager.m
//  pushImage
//
//  Created by 张江威 on 2017/11/10.
//  Copyright © 2017年 YoungMonk. All rights reserved.
//

#import "YMPhotosManager.h"
#import "YMPhotosView.h"

@implementation YMPhotosManager
+ (instancetype)sharedManager
{
    static YMPhotosManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[YMPhotosManager alloc]init];
    });
    return instance;
}

- (void)showPhotosWithfromViews:(NSArray *)fromViews images:(NSArray *)images imageUrls:(NSArray *)imageUrls index:(NSInteger)index{
    
    NSMutableArray *tempArray = @[].mutableCopy;
    NSInteger arrayCount = 0;
    if (fromViews.count) {
        arrayCount = fromViews.count;
    }else if (imageUrls.count){
       arrayCount = imageUrls.count;
    }else if (images.count){
        arrayCount = images.count;
    }
    
    for (NSInteger i=0; i<arrayCount; i++) {
        SQPhotoItem *item = [SQPhotoItem new];
        
        if (fromViews.count) {
            item.thumbView = fromViews[i];
        }
        if (images.count) {
            item.thumbImage = images[i];
        }
        if (imageUrls.count) {
            item.largeImageURL = [NSURL URLWithString:imageUrls[i]];
        }
        [tempArray addObject:item];
    }
    
    YMPhotosView *photoView = [[YMPhotosView alloc]initWithPhotoItems:tempArray];
    [photoView showViewFromIndex:index];
}

@end
