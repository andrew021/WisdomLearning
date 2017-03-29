//
//  ZSRequest+LoginInfo.m
//  WisdomLearning
//
//  Created by Shane on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+LoginInfo.h"

@implementation ZSRequest (LoginInfo)

#pragma mark ****  用户登录接口 ***
-(void)requestLoginUserDataWith:(NSDictionary *)user_Dic withBlock:(void (^)(ZSLoginModel *model,NSError *error))block {
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"login.action";
    if (user_Dic) {
        [requestModel.requestParams addEntriesFromDictionary:user_Dic];
    }
    requestModel.modelClass = [ZSLoginModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSLoginModel *)model, error);
        }
    }];
}

#pragma mark --- 获取验证码
- (void)requestSendValidcodeWithTelphone:(NSString *)telphone block:(void (^)(ZSModel *, NSError *))block
{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"sendValidcode.action";
    if (telphone) {
        [requestModel.requestParams setValue:telphone forKey:@"telphone"];
    }
    requestModel.modelClass = [ZSModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];
}

#pragma mark --- 重置密码
-(void)requestResetPwdWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *, NSError *))block
{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"resetPwd.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];
}


#pragma mark  ---是否绑定了第三方登录---
-(void)isBindThirdPartyWithDict:(NSDictionary *)dict block:(void (^)(ZSLoginModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"isBindThird.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSLoginModel class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSLoginModel *)model, error);
        }
    }];
}

-(void)bindUserAccoutWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"bindAccount.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];

}

-(void)scanToWebpageWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"appscanlogin.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];

}

@end
