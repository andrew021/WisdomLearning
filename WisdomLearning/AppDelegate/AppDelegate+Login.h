//
//  AppDelegate+Login.h
//  threePartyLoginDemo
//
//  Created by Shane on 16/8/18.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Login)

- (void)loginApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
             registerApp:(NSString *)registerApp
                 QQAppId:(NSString *)QQAppId
                QQAppKey:(NSString *)QQAppKey
             weChatAppId:(NSString *)weChatAppId
         weChatAppSecret:(NSString *)weChatAppSecret
             weiboAppKey:(NSString *)weiboAppKey
          weiboAppSecret:(NSString *)weiboAppSecret;

@end
