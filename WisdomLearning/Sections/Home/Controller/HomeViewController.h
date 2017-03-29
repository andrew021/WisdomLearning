//
//  HomeViewController.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/9/30.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UITabBarController

//- (void)showNotificationWithMessage:(EMMessage *)message;

- (void)didReceiveLocalNotification:(UILocalNotification *)notification;
@end
