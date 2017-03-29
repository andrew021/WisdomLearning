//
//  AppDelegate+JPush.m
//  pushNotificationTest
//
//  Created by Shane on 16/10/26.
//  Copyright © 2016年 Shane. All rights reserved.
//

#import "AppDelegate+JPush.h"
#import "UIDevice+YYAdd.h"
#import "ChatViewController.h"



@implementation AppDelegate (JPush)

- (void)jpushApplication:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
                  appkey:(NSString *)appkey
                 channel:(NSString *)channel
        apsForProduction:(BOOL)isProduction{
    
    if ([UIDevice systemVersion] >= 8.0) {
        //可以添加自定义categories
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
         [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    //如不需要使用IDFA，advertisingIdentifier 可为nil
    [JPUSHService setupWithOption:launchOptions appKey:appkey
                          channel:channel
                 apsForProduction:isProduction
            advertisingIdentifier:nil];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [JPUSHService resetBadge];
    
    NSDictionary *remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    NSLog(@"remoteNotification=%@", remoteNotification);
    
    if (remoteNotification) {
        
        UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"远程消息" message:remoteNotification[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
        [view show];

        
//        if (![[Config Instance] isLogin]) {
//            return;
//        }
//        self.launchFromNotification = YES;
//        [self handleNotification:remoteNotification];
    }
    
}

//- (void)application:(UIApplication *)application
//didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
//    
//    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
//    [JPUSHService registerDeviceToken:deviceToken];
//}
//
//- (void)application:(UIApplication *)application
//didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
//    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
//}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"Inactive");
    }else if (application.applicationState == UIApplicationStateBackground){
        NSLog(@"Background");
    }else if (application.applicationState == UIApplicationStateActive){
        NSLog(@"Active");
    }
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"远程消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
    [view show];
    
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    //iOS 7及之后才能用，现在没人适配iOS6了吧...
    // IOS 7 Support Required
    
    
    [JPUSHService handleRemoteNotification:userInfo];
//    NSLog(@"收到通知 :%@", userInfo);
//    completionHandler(UIBackgroundFetchResultNewData);
    
    if (application.applicationState == UIApplicationStateInactive) {
        NSLog(@"Inactive");
        completionHandler(UIBackgroundFetchResultNewData);
    }else if (application.applicationState == UIApplicationStateBackground){
        NSLog(@"Background");
        completionHandler(UIBackgroundFetchResultNewData);
    }else if (application.applicationState == UIApplicationStateActive){
        NSLog(@"Active");
        completionHandler(UIBackgroundFetchResultNewData);
    }
    UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"远程消息" message:userInfo[@"aps"][@"alert"] delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Sure", nil];
    [view show];
    
    



}






//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

@end
