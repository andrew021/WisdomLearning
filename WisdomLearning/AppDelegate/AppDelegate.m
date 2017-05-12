//
//  AppDelegate.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/9/30.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "AppDelegate.h"
#import "UIDevice+YYAdd.h"


#import "AppDelegate+Login.h"
#import "AppDelegate+Share.h"
#import "Config.h"

#import "AppDelegate+JPush.h"

#import <ShareSDK/ShareSDK.h>
//环信SDK
#import "EaseUI.h"
#import "ChatDemoHelper.h"
#import "ChatDemoHelper.h"
#import "AppDelegate+EaseMob.h"

#import "PersonViewController.h"
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

#import "WXApi.h"
#import <AlipaySDK/AlipaySDK.h>

#import "WXApiManager.h"

#import "MsgManageViewController.h"
#import "ChatViewController.h"
#import "NSObject+Tool.h"

#import "UIWindow+LGAlertView.h"

NSString *gHost = @"";
NSString *gIMHost = @"";
NSString *gIconHost = @"";
NSString *indexfunc = @"";
NSString *centerfunc = @"";
NSString *regfunc  = @"";
NSString *outscanewm = @"";
NSString *innerscanewm = @"";
NSString *studymessage = @"";
NSString *studynews = @"";
NSString *orderform = @"";
NSString *lmsurl = @"";
NSString *homeworkSavePath = @"";
NSString *avaterimguploadurl = @"";
NSString *userhomeimguploadurl = @"";
NSString *imguploadurl = @"";
NSString *bindmanageurl = @"";
NSString *useradviceurl = @"";
NSString *regurl = @"";
NSString *edituserinfourl = @"";
NSString *aboutUs = @"";
NSString *functionInfo = @"";
NSString *freshfunc = @"";
NSString *tenantCode = @"";
float coinrule = 1;
NSInteger studysaveinterval = 30;
NSInteger possaveinterval = 60;
NSString *priceunit = @"";   //价格单位
NSString *resunit = @"";  //学分  学时
NSString *coin = @"";  //学币
NSArray *payPaths;
NSString *coinShow = @"";


@interface AppDelegate ()

@property (nonatomic, weak) MsgManageViewController * mainVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
    SideslipSingle *side = [SideslipSingle sharedInstance];
    side.isSideslip = NO;
    
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
   
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *settingDict = [[NSDictionary alloc] initWithContentsOfFile:plistPath][identifier];

    
    NSString * IMAppKey = settingDict[@"IMAPPKey"];
    NSString * IMApnsCerName = settingDict[@"IMapnsCertName"];
    NSString *qqAppId = settingDict[@"QQAppId"];
    NSString *qqAppKey = settingDict[@"QQAppKey"];
    NSString *jPushAppKey = settingDict[@"JPushAppKey"];
    NSString *weChatAppId = settingDict[@"weChatAppId"];
    NSString *weChatAppSecret = settingDict[@"weChatAppSecret"];
    NSString *weiboAppKey = settingDict[@"weiboAppKey"];
    NSString *weiboAppSecret = settingDict[@"weiboAppSecret"];
    NSString *wxPayAppKey = settingDict[@"wxPayAppKey"];
  
    //相对于上面的接口，这个接口可以动画的改变statusBar的前景色
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self loginApplication:application
didFinishLaunchingWithOptions:launchOptions
               registerApp:@"18c453387472b"
                   QQAppId:qqAppId
                  QQAppKey:qqAppKey
               weChatAppId:weChatAppId
           weChatAppSecret:weChatAppSecret
               weiboAppKey:weiboAppKey
            weiboAppSecret:weiboAppSecret];
    
    [self shareApplication:application
        didFinishLaunchingWithOptions:launchOptions
               registerApp:@"18c453387472b"
                   QQAppId:qqAppId
                  QQAppKey:qqAppKey
               weChatAppId:weChatAppId
           weChatAppSecret:weChatAppSecret
               weiboAppKey:weiboAppKey
            weiboAppSecret:weiboAppSecret];
    
    //极光推送
    [self jpushApplication:application didFinishLaunchingWithOptions:launchOptions appkey:
     jPushAppKey channel:@"" apsForProduction:NO];
    
    //微信支付
    //wxa1b685fe8ad0ef99
    [WXApi registerApp:wxPayAppKey withDescription:@"demo 2.0"];
    
    //环信
    // NSString *apnsCertName = @"zhihuixuexi";
    //慧园  1199160928115567#jsstudy
    //智搜 zhisou#bm
    //个人 zhisou#zhihuixuexi001
    
    
  //IMAppKey = @"1199160928115567#jsstudy";
  //IMApnsCerName = @"zhihuixuexi";
    

    
    
    //高德定位
    [AMapServices sharedServices].apiKey = [Tool getMapAppKey];
//    [AMapLocationServices sharedServices].apiKey =  [Tool getMapAppKey];
   
    //请求分类数据
    ZSRequest* request = [ZSRequest new];
    NSDictionary *dict = @{@"isDebug":@"0"};
    [request requesSystemSetWithDict:dict Block:^(ZSSystemSetModel *model, NSError *error) {
        if(model.isSuccess){
            
            for (SystemSetModel *theModel in model.data) {
                NSString *code = theModel.configCode;
                NSString *value = theModel.configValue;
                
                if ([code isEqualToString:@"bus_host"]) {
                    gHost = value;
                }else if ([code isEqualToString:@"im_host"]){
                    gIMHost = value;
                    [[GroupsManager sharedGroupsManager] allGroupsWithUserId:gUserID completionBlock:nil];
                    // [[ContactsManager sharedContactsManager] getAllConversationCompletionBlock:nil];
                    [[ContactsManager sharedContactsManager] allContactsWithUserId:gUserID completionBlock:nil];
                }else if ([code isEqualToString:@"img_host"]){
                    gIconHost = value;
                }else if ([code isEqualToString:@"indexfunc"]){
                    indexfunc = value;
                }else if ([code isEqualToString:@"centerfunc"]){
                    centerfunc = value;
                }else if ([code isEqualToString:@"regfunc"]){
                    regfunc = value;
                }else if ([code isEqualToString:@"outscanewm"]){
                    outscanewm = value;
                }else if ([code isEqualToString:@"innerscanewm"]){
                    innerscanewm = value;
                }else if ([code isEqualToString:@"studymessage"]){
                    studymessage = value;
                }else if ([code isEqualToString:@"studynews"]){
                    studynews = value;
                }else if ([code isEqualToString:@"orderform"]){
                    orderform = value;
                }else if ([code isEqualToString:@"lmsurl"]){
                    lmsurl = value;
                }else if ([code isEqualToString:@"homeworkSavePath"]){
                    homeworkSavePath = value;
                }else if ([code isEqualToString:@"userhomeimguploadurl"]){
                    userhomeimguploadurl = value;
                }else if ([code isEqualToString:@"avaterimguploadurl"]){
                    avaterimguploadurl = value;
                }else if ([code isEqualToString:@"bindmanageurl"]){
                    bindmanageurl = value;
                }else if ([code isEqualToString:@"useradviceurl"]){
                    useradviceurl = value;
                } else if ([code isEqualToString:@"freshfunc"]) {
                    freshfunc = value;
                }else if([code isEqualToString:@"regurl"]){
                    regurl = value;
                }else if ([code isEqualToString:@"edituserinfourl"]){
                    edituserinfourl = value;
                }else if ([code isEqualToString:@"imguploadurl"]){
                    imguploadurl = value;
                }else if ([code isEqualToString:@"abouturl"]) {
                    aboutUs = value;
                }else if ([code isEqualToString:@"funcdescurl"]) {
                    functionInfo = value;
                }else if ([code isEqualToString:@"tenantCode"]) {
                    tenantCode = value;
                }else if ([code isEqualToString:@"coinrule"]) {
                    coinrule = [value floatValue];
                }else if ([code isEqualToString:@"studysaveinterval"]){
                    studysaveinterval = [value integerValue];
                }else if ([code isEqualToString:@"possaveinterval"]){
                    possaveinterval = [value integerValue];
                }else if ([code isEqualToString:@"paypath"]){
                    payPaths = [value componentsSeparatedByString:@","];
                }else if ([code isEqualToString:@"priceunit"]){
                    priceunit = value;
                }else if ([code isEqualToString:@"resunit"]){
                    resunit = value;
                }else if ([code isEqualToString:@"coin"]){
                    coin = value;
                }else if ([code isEqualToString:@"coinShow"]){
                    coinShow = value;
                }
            }
            
          
    
            
            HomeViewController *vc = [HomeViewController new];
            self.homeNav = [[MyNavigationController alloc]initWithRootViewController:vc];
            [self.homeNav setNavigationBarHidden:YES animated:NO];
            
            PersonViewController *leftVC = [[PersonViewController alloc] init];
            self.LeftSlideVC = [[LeftSlideViewController alloc] initWithLeftView:leftVC andMainView:self.homeNav];
            [self.LeftSlideVC setPanEnabled:NO];
            self.window.rootViewController = self.LeftSlideVC;
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"getData" object:self];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [request requestCategoriesListNumberWithBlock:^(ZSCategoryListModel *model, NSError *error) {
                    if (model.isSuccess) {
                        NSMutableArray * arr = [NSMutableArray array];
                        [arr addObjectsFromArray:model.data];
                        
                        ZSCategoryInfo *info = [[ZSCategoryInfo alloc]init];
                        info.id = @"";
                        info.name = @"全部课程";
                        info.busCount = @"0";
                        info.childCount = @"0";;
                        info.subs = [NSMutableArray arrayWithArray:@[]];
                        [arr insertObject:info atIndex:0];
                        [[Config Instance] saveCategories:arr];
                    }else{
                        //                [self showHint:model.message];
                    }
                }];
                //请求资讯分类数据
                [request requestNewsCategoryBlock:^(ZSCategoryListModel *model, NSError *error) {
                    if (model.isSuccess) {
                        NSMutableArray * arr = [NSMutableArray array];
                        [arr addObjectsFromArray:model.data];
                        
                        ZSCategoryInfo *info = [[ZSCategoryInfo alloc]init];
                        info.id = @"";
                        info.name = @"全部资讯";
                        info.busCount = @"0";
                        info.childCount = @"0";
                        info.subs = [NSMutableArray arrayWithArray:@[]];
                        [arr insertObject:info atIndex:0];
                        [[Config Instance] saveNewCategories:arr];
                    }
                }];
                
                [request requestIntelligentOrderWithType:@"course" WithBlock:^(ZSIntelligentOrderModel *model, NSError *error) {
                    if(model.isSuccess){
                        [TypeManager sharedAPI].IntelligentOrder = model.data;
                    }
                }];
                
                [request requestFilterFieldWithType:@"course" WithBlock:^(ZSFilterFieldModel *model, NSError *error) {
                    if(model.isSuccess){
                        [TypeManager sharedAPI].filterFields = model.data;
                    }
                }];
                
                [request requestIntelligentOrderWithType:@"program" WithBlock:^(ZSIntelligentOrderModel *model, NSError *error) {
                    if(model.isSuccess){
                        [TypeManager sharedAPI].proIntelligentOrder = model.data;
                    }
                }];
                
                [request requestFilterFieldWithType:@"program" WithBlock:^(ZSFilterFieldModel *model, NSError *error) {
                    if(model.isSuccess){
                        [TypeManager sharedAPI].proFilterFields = model.data;
                    }
                }];

            });
        }
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请求接口地址失败" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
    
    [self easemobApplication:application
didFinishLaunchingWithOptions:launchOptions
                      appkey:IMAppKey
                apnsCertName:IMApnsCerName
                 otherConfig:@{ kSDKConfigEnableConsoleLogger : [NSNumber numberWithBool:YES] }];
    
    [self loginIMWithUserName:gUserID andPassWord:@"111111"];

    return YES;
}


- (void)loginEaseMob
{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* username = [ud objectForKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
    NSString* password = [ud objectForKey:@"em_lastLogin_password"];
    EMError* error = [[EMClient sharedClient] loginWithUsername:username password:password];
    if (!error) {
        [[EMClient sharedClient].options setIsAutoLogin:YES];
    }
}

- (void)applicationDidEnterBackground:(UIApplication*)application
{
    [[EMClient sharedClient] applicationDidEnterBackground:application];
   
    NSLog(@"*** %@",[self currentViewController]);
}


-(UIViewController*)findBestViewController:(UIViewController*)vc {
    if (vc.presentedViewController) {
        // Return presented view controller
        return [self findBestViewController:vc.presentedViewController];
    }
  //      else if [vc isKindOfClass:[UISplitViewController class]]) {
//        // Return right hand side
//        UISplitViewController svc = (UISplitViewController*) vc;
//        if (svc.viewControllers.count > 0)
//            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
//        else
//            return vc;
//    }
    else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController *svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.topViewController];
        else
            return vc;
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // Return visible view
        UITabBarController * svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [self findBestViewController:svc.selectedViewController];
        else
            return vc;
    } else {
        // Unknown view controller type, return last child view controller
        return vc;
    }
}
-(UIViewController*)currentViewController {
    // Find best view controller
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self findBestViewController:viewController];
}


- (void)applicationWillEnterForeground:(UIApplication*)application
{
    [[EMClient sharedClient] applicationWillEnterForeground:application];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)didConnectionStateChanged:(EMConnectionState)aConnectionState
{
   // NSLog(@"改变 %u", aConnectionState);
    [self loginEaseMob];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}



- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    if ([url.scheme isEqualToString:[Tool getAppScheme]]) {
        if ([url.host isEqualToString:@"safepay"]){   //支付宝支付
            return [[AliPayManager sharedManager] handleOpenURL:url];
        }else if ([url.host isEqualToString:@"uppayresult"]){  //银联支付
            return [[UnionPayManager sharedManager] handleOpenURL:url];
        }
    }
    
    if ([url.scheme isEqualToString:[Tool getWxPayKey]]) {
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }

    
    return YES;

}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.scheme isEqualToString:[Tool getAppScheme]]) {
        if ([url.host isEqualToString:@"safepay"]){   //支付宝支付
            return [[AliPayManager sharedManager] handleOpenURL:url];
        }else if ([url.host isEqualToString:@"uppayresult"]){  //银联支付
            return [[UnionPayManager sharedManager] handleOpenURL:url];
        }
    }
    
    if ([url.scheme isEqualToString:[Tool getWxPayKey]]) {
        if ([url.host isEqualToString:@"pay"]) {
            return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
        }
    }
    

    return YES;
}


#pragma mark  ---Device Token---
- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    NSLog(@"%@", [NSString stringWithFormat:@"Device Token: %@", deviceToken]);
    [JPUSHService registerDeviceToken:deviceToken];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[EMClient sharedClient] bindDeviceToken:deviceToken];
//        
//        [[EMClient sharedClient] registerForRemoteNotificationsWithDeviceToken:deviceToken completion:^(EMError *aError) {
//            if(!aError){
//                NSLog(@"成功!");
//            }
//            else{
//                 NSLog(@"失败!");
//            }
//        }];
    
  
    });
}

- (void)codeRegisterOfflinePush:(UIApplication*)application
{
    //iOS8 注册APNS
    
   
    if ([application respondsToSelector:@selector(registerForRemoteNotifications)]) {
        [application registerForRemoteNotifications];
        UIUserNotificationType notificationTypes = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings* settings = [UIUserNotificationSettings settingsForTypes:notificationTypes categories:nil];
        [application registerUserNotificationSettings:settings];
    }
    else {
        UIRemoteNotificationType notificationTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:notificationTypes];
    }
}

- (void)application:(UIApplication *)application
didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
//    if(_home){
//     [self.home didReceiveLocalNotification:notification];
//    }
//    
    //HomeViewController *vc = [HomeViewController new];
    //[vc didReceiveLocalNotification:notification];
    
    if([[self currentController] isKindOfClass:[ChatViewController class]]){
        return;
        
    }

    NSDictionary* userInfo  = [[NSDictionary alloc]init];

//    
    userInfo = notification.userInfo;
    NSString * str =  userInfo[@"ConversationChatter"];
    EMConversationType messageType= [userInfo[@"MessageType"] intValue];

    ChatViewController* chatController = [[ChatViewController alloc] initWithConversationChatter:str conversationType:messageType];
    chatController.hidesBottomBarWhenPushed = YES;
    chatController.ID = str;
    chatController.title = userInfo[@"notiNickName"];;
     // NSLog(@"++ %@",[self currentController])
    
    [[self currentController].navigationController pushViewController:chatController animated:NO];
    // UIViewController *currentVC = [self getCurrentVC];
   
    // [[self currentController].navigationController pushViewController:chatController animated:YES];
    NSLog(@"*** %@",[self currentViewController]);
//
//    // [currentVC.navigationController pushViewController:chatController animated:YES];
//    
}


////获取当前屏幕显示的viewcontroller
//- (UIViewController *)getCurrentVC
//{
//    UIViewController *result = nil;
//    
//    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
//    if (window.windowLevel != UIWindowLevelNormal)
//    {
//        NSArray *windows = [[UIApplication sharedApplication] windows];
//        for(UIWindow * tmpWin in windows)
//        {
//            if (tmpWin.windowLevel == UIWindowLevelNormal)
//            {
//                window = tmpWin;
//                break;
//            }
//        }
//    }
//    
//    UIView *frontView = [[window subviews] objectAtIndex:3];
//    id nextResponder = [frontView nextResponder];
//    
//    if ([nextResponder isKindOfClass:[UIViewController class]])
//        result = nextResponder;
//    else
//        result = window.rootViewController;
//    
//    return result;
//}

//暂时登录
-(void)loginIMWithUserName:(NSString*)userName andPassWord:(NSString*)passWord{
    __weak typeof(self) weakself = self;
    //  NSLog(@"%@ %@",userName,passWord)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        EMError* error = [[EMClient sharedClient] loginWithUsername:userName password:passWord];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (!error) {
                //设置是否自动登录
              
                
                [[EMClient sharedClient].options setIsAutoLogin:YES];
                
                [[GroupsManager sharedGroupsManager] allGroupsWithUserId:gUserID completionBlock:nil];
                [[ContactsManager sharedContactsManager] allContactsWithUserId:gUserID completionBlock:nil];
                [[EMClient sharedClient] getPushNotificationOptionsFromServerWithCompletion:^(EMPushOptions *aOptions, EMError *aError) {
                    
                    if (!aError) {
                        EMPushOptions *option = [[EMClient sharedClient] pushOptions];
                        option.displayStyle = EMPushDisplayStyleMessageSummary;
                        //  option.nickname = gUserName;
                        EMError* error = [[EMClient sharedClient] setApnsNickname:gUserNickname];
                        
                    }
                }];
                
                [[EMClient sharedClient] updatePushOptionsToServer];
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[EMClient sharedClient] dataMigrationTo3];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //发送自动登陆状态通知
                        //发送自动登陆状态通知
                        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_LOGINCHANGE object:@([[EMClient sharedClient] isLoggedIn])];
                        
                        NSString* password = passWord;
                        
                        if (password && password.length > 0) {
                            //                            NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
                            //                            [ud setObject:password forKey:[NSString stringWithFormat:@"em_lastLogin_password"]];
                            //
                            //                            [ud setObject:userName forKey:@"em_lastLogin_username"];
                            //                            [ud synchronize];
                        }
                        //保存最近一次登录用户名
                        // [weakself saveLastLoginUsername];
                    });
                });
            }
            else {
               
                switch (error.code) {
                        
                    case EMErrorNetworkUnavailable:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        //[self loginWithPassWord:password AndUserId:userId];
                        break;
                    case EMErrorServerNotReachable:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        // [self loginWithPassWord:password AndUserId:userId];
                        break;
                    case EMErrorUserAuthenticationFailed:
                        //[self loginWithPassWord:password AndUserId:userId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        break;
                    case EMErrorServerTimeout:
                        //[self loginWithPassWord:password AndUserId:userId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        break;
                    default:
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"loginIMAgain" object:self];
                        //[self loginWithPassWord:password AndUserId:userId];
                        break;
                }
            }
        });
        
    });
    
}





#pragma  mark - private
- (void)saveLastLoginUsername
{
    NSString *username = [[EMClient sharedClient] currentUsername];
    if (username && username.length > 0) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:username forKey:[NSString stringWithFormat:@"em_lastLogin_username"]];
        [ud synchronize];
    }
}

@end
