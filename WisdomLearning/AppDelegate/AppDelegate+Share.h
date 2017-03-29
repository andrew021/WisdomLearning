//
//  AppDelegate+Share.h
//  WisdomLearning
//
//  Created by Shane on 16/10/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Share)

- (void)shareApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
             registerApp:(NSString *)registerApp
                 QQAppId:(NSString *)QQAppId
                QQAppKey:(NSString *)QQAppKey
             weChatAppId:(NSString *)weChatAppId
         weChatAppSecret:(NSString *)weChatAppSecret
             weiboAppKey:(NSString *)weiboAppKey
          weiboAppSecret:(NSString *)weiboAppSecret;

@end
