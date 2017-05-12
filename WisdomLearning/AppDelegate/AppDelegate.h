//
//  AppDelegate.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/9/30.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EMChatManagerDelegate.h"
#import "EMContactManagerDelegate.h"
#import "EMGroupManagerDelegate.h"

#import "LeftSlideViewController.h"
#import "HomeViewController.h"
#import "MyNavigationController.h"


extern NSString *gIconHost;
extern NSString *resunit;
extern NSString *priceunit;
extern float coinrule;
extern NSInteger studysaveinterval;
extern NSArray *payPaths;
extern NSString *coin;
extern NSString *coinShow;

@interface AppDelegate : UIResponder <UIApplicationDelegate, EMChatManagerDelegate, EMContactManagerDelegate, EMGroupManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LeftSlideViewController *LeftSlideVC;
@property (strong, nonatomic) MyNavigationController *homeNav;

@property (strong, nonatomic)HomeViewController * home;
@end

