//
//  ZSRequest+LoginInfo.h
//  WisdomLearning
//
//  Created by Shane on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSLoginModel.h"


@interface ZSRequest (LoginInfo)


#pragma mark ****  用户登录接口 ***
-(void)requestLoginUserDataWith:(NSDictionary *)user_Dic withBlock:(void (^)(ZSLoginModel *model,NSError *error))block;

/**
 *  获取验证码
 *
 *  @param telphone   手机号
 *  @param block      返回Block
 */
-(void)requestSendValidcodeWithTelphone:(NSString *)telphone block:(void (^)(ZSModel *model, NSError *error))block;

/**
 *  重置密码
 *
 *  @param block      返回Block
 */
-(void)requestResetPwdWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block;

#pragma mark  ---是否绑定了第三方登录---
-(void)isBindThirdPartyWithDict:(NSDictionary *)dict block:(void (^)(ZSLoginModel *model, NSError *error))block;

#pragma mark  ---第三方登录绑定用户名---
-(void)bindUserAccoutWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block;

#pragma mark  ---客户端使用扫描登录进入网页---
-(void)scanToWebpageWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block;

@end
