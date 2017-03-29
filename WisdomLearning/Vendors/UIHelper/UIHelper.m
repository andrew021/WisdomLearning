//
//  UIHelper.m
//  gtja_iphone_yht
//
//  Created by Vincent on 13-7-26.
//  Copyright (c) 2013年 huwp. All rights reserved.
//

#import "UIHelper.h"

#import "UIAlertView+Blocks.h"


@implementation UIHelper

+ (void)alert:(NSString *)message completionBlock:(void (^)(void))completion
{
    [UIAlertView showWithTitle:@"" message:message handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (completion) {
            completion();
        }
        
    }];
}

+ (void)alertWithTitle:(NSString *)title AndMessage:(NSString *)message completionBlock:(void (^)(void))completion{
    [UIAlertView showWithTitle:title message:message handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (completion) {
            completion();
        }
        
    }];
}

@end
