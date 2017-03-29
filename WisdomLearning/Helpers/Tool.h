//
//  Tool.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tool : NSObject

//隐藏键盘
+ (void)hideKeyBoard;

//判断是否为手机号
+ (BOOL)isMobileNumber:(NSString *)mobileNum;

//获取导航栏 tabBar 颜色
+(UIColor *)getMainColor;

//获取导航栏 tabBar 颜色
+(UIColor *)getLoginButtonColor;

//获取 高德 appKey
+(NSString *)getMapAppKey;

+(NSString *)getAppScheme;

+(NSString *)getWxPayKey;

+(NSString *)getOrderUnit;

//获取首页功能模块
+(NSArray *)getAppHomeFunctionModule;
//获取菜单名称
+(NSString *)getAppMenuName;
+(NSString *)getSelfStudyTitle;
// 获取资讯的图片
+(NSString *)getLogoNewsImageName;

//获取搜索提示配置
+(NSArray *)getAppSearchModule;

@end
