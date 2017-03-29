//
//  NSObject+Tool.m
//  WisdomLearning
//
//  Created by DiorSama on 2017/3/7.
//  Copyright © 2017年 hfcb001. All rights reserved.
//

#import "NSObject+Tool.h"
#import "UIView+Tool.h"

@implementation NSObject (Tool)

//通过控制器的布局视图可以获取到控制器实例对象    modal的展现方式需要取到控制器的根视图
-(UIViewController*)currentController
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    // modal展现方式的底层视图不同
    // 取到第一层时，取到的是UITransitionView，通过这个view拿不到控制器
    UIView *firstView = [keyWindow.subviews firstObject];
    UIView *secondView = [firstView.subviews firstObject];
    UIViewController *vc = [secondView parentController];
  
    if ([vc isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tab = (UITabBarController *)vc;
        if ([tab.selectedViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)tab.selectedViewController;
            return [nav.viewControllers lastObject];
        } else {
            return tab.selectedViewController;
        }
    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)vc;
        return [nav.viewControllers lastObject];
    }
    else {
        return vc;
    }
    return nil;
}
@end
