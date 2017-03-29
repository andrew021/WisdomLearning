//
//  Config.m
//  ElevatorUncle
//
//  Created by hfcb001 on 16/6/17.
//  Copyright © 2016年 hfcb001. All rights reserved.
//


//NSString *kWltpUserIcon = @"user_icon";
//NSString *kWltpUserName = @"user_name";
NSString *kWlThridPartyUserInfo = @"thirty_party_info";
NSString *kWlLoginInfo = @"login_info";
NSString *kWlLearnCoin = @"user_learn_coin";
NSString *kWlSystemSet = @"user_system_set";
NSString *kWlSystemIM = @"user_system_im";

#import "Config.h"

@interface Config() {
    NSUserDefaults *_defaults;
}

@end

@implementation Config

-(instancetype)init{
    if (self = [super init]) {
        _defaults = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

+ (Config*)Instance
{
    static Config* sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}
#pragma mark - 是否登录
//是否登录
- (BOOL)isLogin {
    if ([self getUsername].length != 0 && [self getUserid].length != 0) {
        return YES;
    }
    return NO;
}


//-(void)saveUsericon:(NSString *)usericon{
//    [_defaults setObject:usericon forKey:kWltpUserIcon];
//    [_defaults synchronize];
//}

-(NSString *)getUsericon{
//    return [_defaults objectForKey:kWltpUserIcon];
    ZSLoginInfo *loginInfo = [self getLoginInfo];
    if (loginInfo.userIcon == nil || loginInfo.userIcon == [NSNull class]) {
        return @"";
    }
    return loginInfo.userIcon;
}


-(NSString *)getUserid{
    ZSLoginInfo *loginInfo = [self getLoginInfo];
    if (loginInfo.userId == nil || loginInfo.userId == [NSNull class]) {
        return @"";
    }
    return loginInfo.userId;
}

-(NSString *)getUserNickname{
    ZSLoginInfo *loginInfo = [self getLoginInfo];
    if (loginInfo.nickName == nil || loginInfo.nickName == [NSNull class]) {
        return @"";
    }
    return loginInfo.nickName;
}

//-(void)saveUsername:(NSString *)username{
//    [_defaults setObject:username forKey:kWltpUserName];
//    [_defaults synchronize];
//}


-(NSString *)getUsername{
    ZSLoginInfo *loginInfo = [self getLoginInfo];
    if (loginInfo.userName == nil || loginInfo.userName == [NSNull class]) {
        return @"";
    }
    return loginInfo.userName;
}


-(void)saveSystemSet:(NSString *)SyetemSet
{
    [_defaults setObject:SyetemSet forKey:kWlSystemSet];
    [_defaults synchronize];
    
}


-(NSString*)getSystemSet
{
    NSString * str = [_defaults objectForKey:kWlSystemSet];
    return str;
}

-(void)saveSystemIM:(NSString *)SyetemIM{
    [_defaults setObject:SyetemIM forKey:kWlSystemIM];
    [_defaults synchronize];
}
-(NSString *)getSystemIM{
    NSString * str = [_defaults objectForKey:kWlSystemIM];
    return str;
}


-(void)saveThirtyPartyUserInfo:(SSEBaseUser *)user{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];
    [_defaults setObject:data forKey:kWlThridPartyUserInfo];
    [_defaults synchronize];
}

-(SSEBaseUser *)getThirtyPartyUserInfo{
    NSData *data = [_defaults objectForKey:kWlThridPartyUserInfo];
    return (SSEBaseUser *)[NSKeyedUnarchiver unarchiveObjectWithData:data];
}

-(void)saveLoginInfo:(ZSLoginInfo *)loginInfo{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:loginInfo];
    [_defaults setObject:data forKey:kWlLoginInfo];
    [_defaults synchronize];
}

-(ZSLoginInfo *)getLoginInfo{
    NSData *data = [_defaults objectForKey:kWlLoginInfo];
    ZSLoginInfo *loginInfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return loginInfo;
}

-(void)saveCategories:(NSArray<ZSCategoryInfo *> *)categories{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:categories];
    [_defaults setObject:data forKey:@"categories"];
}

-(NSArray<ZSCategoryInfo *> *)getCategories{
    NSData *data = [_defaults objectForKey:@"categories"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}


-(void)saveNewCategories:(NSArray<ZSCategoryInfo *> *)categories{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:categories];
    [_defaults setObject:data forKey:@"newCategories"];
}

-(NSArray<ZSCategoryInfo *> *)getNewCategories{
    NSData *data = [_defaults objectForKey:@"newCategories"];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

#pragma mark - 清空用户数据
- (void)clearUserData {
//    [_defaults removeObjectForKey:kWltpUserName];
//    [_defaults removeObjectForKey:kWltpUserIcon];
    [_defaults removeObjectForKey:kWlThridPartyUserInfo];
    [_defaults removeObjectForKey:kWlLoginInfo];
}




@end
