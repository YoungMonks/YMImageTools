//
//  YMActionSheetView.h
//  pushImage
//
//  Created by 张江威 on 2017/11/10.
//  Copyright © 2017年 YoungMonk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YMActionSheetView : UIView

@property (nonatomic, copy) void(^buttonClick)(YMActionSheetView *sheetView,NSInteger buttonIndex);

- (id)initWithTitle:(NSString *)title buttons:(NSArray <NSString *>*)buttons buttonClick:(void(^)(YMActionSheetView *sheetView,NSInteger buttonIndex))block;

- (void)showView;
@end
