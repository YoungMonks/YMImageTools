//
//  YMPhotosManager.h
//  pushImage
//
//  Created by 张江威 on 2017/11/10.
//  Copyright © 2017年 YoungMonk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YMPhotosManager : NSObject
+ (instancetype)sharedManager;

- (void)showPhotosWithfromViews:(NSArray *)fromViews images:(NSArray *)images imageUrls:(NSArray *)imageUrls index:(NSInteger)index;
@end
