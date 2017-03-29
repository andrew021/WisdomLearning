//
//  UIView+Tool.m
//  WisdomLearning
//
//  Created by DiorSama on 2017/3/7.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "UIView+Tool.h"

@implementation UIView (Tool)

- (UIViewController *)parentController
{
    UIResponder *responder = [self nextResponder];
    while (responder) {
        if ([responder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)responder;
        }
        responder = [responder nextResponder];
    }
    return nil;
}

@end
