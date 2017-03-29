//
//  Config.h
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//  系统配置

#import <Foundation/Foundation.h>
#import "ZSCategoryListModel.h"
#import "ZSLoginModel.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>


@interface Config : NSObject

+ (Config*)Instance;

#pragma mark - 是否登录
//是否登录
- (BOOL)isLogin;


#pragma mark - 保存用户所有信息

//针对第三方登录的昵称和图像
-(NSString *)getUserNickname;
-(NSString *)getUserid;
-(NSString *)getUsername;

//-(void)saveUsericon:(NSString *)usericon;
-(NSString *)getUsericon;

//第三方登录信息
-(void)saveThirtyPartyUserInfo:(SSEBaseUser *)user;
-(SSEBaseUser *)getThirtyPartyUserInfo;

//账号方式登录信息
-(void)saveLoginInfo:(ZSLoginInfo *)loginInfo;
-(ZSLoginInfo *)getLoginInfo;



//-(void)saveSystemSet:(NSString *)SyetemSet;
//-(NSString *)getSystemSet;

-(void)saveSystemIM:(NSString *)SyetemIM;
-(NSString *)getSystemIM;

//课程分类
-(void)saveCategories:(NSArray<ZSCategoryInfo *> *) categories;
-(NSArray<ZSCategoryInfo *> *)getCategories;

//资讯分类
-(void)saveNewCategories:(NSArray<ZSCategoryInfo *> *) categories;
-(NSArray<ZSCategoryInfo *> *)getNewCategories;

//清空用户数据
- (void)clearUserData;

@end
