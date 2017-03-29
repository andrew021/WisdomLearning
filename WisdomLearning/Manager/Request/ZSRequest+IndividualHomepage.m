//
//  ZSRequest+IndividualHomepage.m
//  WisdomLearning
//
//  Created by Shane on 16/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+IndividualHomepage.h"

@implementation ZSRequest (IndividualHomepage)


#pragma mark ****  个人主页接口 ***
-(void)requestIndividalDetailtWith:(NSDictionary *) dict withBlock:(void (^)(ZSIndividualDetailModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"userHome.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSIndividualDetailModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSIndividualDetailModel *)model, error);
        }
    }];

}

#pragma mark **** 密码修改 ***
-(void)requestEditPassword:(NSString *)userId
                  password:(NSString *)password
               newPassword:(NSString*)newPassword
                     block:(void (^)(ZSModel* model, NSError* error))block
{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"setpwd.action";
    if (userId) {
        [requestModel.requestParams setObject:userId forKey:@"userId"];
    }
    if (password) {
        [requestModel.requestParams setObject:password forKey:@"password"];
    }
    if (newPassword) {
        [requestModel.requestParams setObject:newPassword forKey:@"newPassword"];
    }
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];
}

@end
