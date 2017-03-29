//
//  Tool.m
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "Tool.h"

@implementation Tool

//隐藏键盘
+ (void)hideKeyBoard{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        NSArray *array=[UIApplication sharedApplication].windows;
        keyWindow=[array objectAtIndex:0];
    }
    [keyWindow endEditing:YES];
}


//判断是否为手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum
{
    NSString *mobile = @"^1[34758][0-9]\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",mobile];
    return [phoneTest evaluateWithObject:mobileNum];
}

//获取导航栏 tabBar 颜色
+(UIColor *)getMainColor
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    NSString *ColorValue = [valueDic objectForKey:@"ColorValue"];
    return [UIColor colorFromHexString:ColorValue];
}

//获取导航栏 tabBar 颜色
+(UIColor *)getLoginButtonColor
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    NSString *ColorValue = [valueDic objectForKey:@"loginButtonColorValue"];
    return [UIColor colorFromHexString:ColorValue];
}

//获取 高德 appKey
+(NSString *)getMapAppKey
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    return [valueDic objectForKey:@"HighMoralMap"];
}

+(NSString *)getAppScheme{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    return [valueDic objectForKey:@"appScheme"];
}

+(NSString *)getWxPayKey{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    return [valueDic objectForKey:@"wxPayAppKey"];

}

+(NSString *)getOrderUnit{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    return [valueDic objectForKey:@"myOrderUnit"];
}


+(NSString *)getSelfStudyTitle{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    NSString *sss =[valueDic objectForKey:@"selfStudyTitle"];
    if (sss == nil) {
        sss = @"选课";
    }
    return sss;
}

//获取首页功能模块
+(NSArray *)getAppHomeFunctionModule
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[valueDic objectForKey:@"HomeOrder"]];
    return array;
}

//获取搜索提示配置
+(NSArray *)getAppSearchModule
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    NSMutableArray *array = [NSMutableArray arrayWithArray:[valueDic objectForKey:@"SearchHint"]];
    return array;
}

//获取菜单名称
+(NSString *)getAppMenuName
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"mySettingConfig" ofType:@"plist"];
    NSDictionary *dictRoot = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSDictionary * valueDic = [dictRoot objectForKey:identifier];
    return [valueDic objectForKey:@"MenuName"];
}

// 获取资讯的图片
+(NSString *)getLogoNewsImageName
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    if ([identifier isEqualToString:@"com.witfore.xxapp.wxjy"] || [identifier isEqualToString:@"com.witfore.xxapp.ahsp"]) {
        //无锡. 安徽sp
        return @"app_news";
    } else {
        //江苏.河北.安徽
        return @"app_news_blue";
    }
}



@end
