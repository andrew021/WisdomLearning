//
//  UIHelper.h
//  gtja_iphone_yht
//
//  Created by Vincent on 13-7-26.
//  Copyright (c) 2013年 huwp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface UIHelper : NSObject

+ (void)alert:(NSString *)message completionBlock:(void (^)(void))completion;
+ (void)alertWithTitle:(NSString *)title AndMessage:(NSString *)message completionBlock:(void (^)(void))completion;


//+ (void)confirmTitle:(NSString *)title message:(NSString *)message completion:(void (^)(BOOL isConfirm))completion;
//// 添加 按钮“取消”在左， “确定”在右
//+ (void)confirmTitle2:(NSString *)title message:(NSString *)message completion:(void (^)(BOOL isConfirm))completion;
//// 添加自定义左、右按钮
//+ (void)confirmTitle3:(NSString *)title message:(NSString *)message leftTip:(NSString *)leftTip rightTip:(NSString *)rightTip completion:(void (^)(NSInteger buttonIndex))completion;




@end
