//
//  AppDelegate+Login.m
//  threePartyLoginDemo
//
//  Created by Shane on 16/8/18.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "AppDelegate+Login.h"

#import <ShareSDK/ShareSDK.h>

#import <ShareSDKConnector/ShareSDKConnector.h>

// 腾讯开放平台（对应 QQ 和 QQ 空间） SDK 头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

// 微信 SDK 头文件
#import "WXApi.h"

// 新浪微博 SDK 头文件
#import "WeiboSDK.h"

@implementation AppDelegate (Login)


-(void)loginApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions registerApp:(NSString *)registerApp QQAppId:(NSString *)QQAppId QQAppKey:(NSString *)QQAppKey weChatAppId:(NSString *)weChatAppId weChatAppSecret:(NSString *)weChatAppSecret weiboAppKey:(NSString *)weiboAppKey
         weiboAppSecret:(NSString *)weiboAppSecret{
    
    [ShareSDK registerApp:registerApp activePlatforms:@[ @(SSDKPlatformTypeSinaWeibo),
                                                         @(SSDKPlatformTypeWechat),
                                                         @(SSDKPlatformTypeQQ)
                                                         ]
                 onImport:^(SSDKPlatformType platformType) {
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class]];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                             break;
                         case SSDKPlatformTypeSinaWeibo:
                             [ShareSDKConnector connectWeibo:[ WeiboSDK class]];
                             break;
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary* appInfo) {
              switch (platformType) {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:weChatAppId appSecret:weChatAppSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:QQAppId appKey:QQAppKey authType:SSDKAuthTypeBoth];
                      break;  //@"https://api.weibo.com/oauth2/default.html"
                 case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey : weiboAppKey appSecret:weiboAppSecret
                                              redirectUri : @"http://www.witfore.com/jscas/third_login/sina"
                                                 authType : SSDKAuthTypeBoth ];
                      break;
                  default:
                      break;
              }
          }];

}

@end
