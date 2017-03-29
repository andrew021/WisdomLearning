//
//  AppDelegate+Share.m
//  WisdomLearning
//
//  Created by Shane on 16/10/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AppDelegate+Share.h"

#import <ShareSDK/ShareSDK.h>

#import <ShareSDKConnector/ShareSDKConnector.h>

// 腾讯开放平台（对应 QQ 和 QQ 空间） SDK 头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

// 微信 SDK 头文件
#import "WXApi.h"

// 新浪微博 SDK 头文件
#import "WeiboSDK.h"

@implementation AppDelegate (Share)

-(void)shareApplication:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions registerApp:(NSString *)registerApp QQAppId:(NSString *)QQAppId QQAppKey:(NSString *)QQAppKey weChatAppId:(NSString *)weChatAppId weChatAppSecret:(NSString *)weChatAppSecret weiboAppKey:(NSString *)weiboAppKey weiboAppSecret:(NSString *)weiboAppSecret{
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。我们Demo提供的appKey为内部测试使用，可能会修改配置信息，请不要使用。
     *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    [ShareSDK registerApp:registerApp
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformSubTypeWechatSession),
                            @(SSDKPlatformSubTypeWechatTimeline),
                            @(SSDKPlatformTypeQQ),
//                            @(SSDKPlatformTypeTencentWeibo),
//                            @(SSDKPlatformTypeWechat)
                            ]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType)
                     {

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
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType)
              {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:weChatAppId appSecret:weChatAppSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:QQAppId appKey:QQAppKey authType:SSDKAuthTypeBoth];
                      break;
                  case SSDKPlatformTypeSinaWeibo:
                      [appInfo SSDKSetupSinaWeiboByAppKey : weiboAppKey appSecret:weiboAppSecret
                                              redirectUri : @"http://www.witfore.com/jscas/third_login/sina"
                                                 authType : SSDKAuthTypeBoth ];
                      break;
                  default:
                      break;

              }
          }];
    
    return ;

}

@end
