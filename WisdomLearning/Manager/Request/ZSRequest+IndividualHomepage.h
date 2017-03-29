//
//  ZSRequest+IndividualHomepage.h
//  WisdomLearning
//
//  Created by Shane on 16/11/8.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSIndividualDetailModel.h"

@interface ZSRequest (IndividualHomepage)

#pragma mark ****  个人主页接口 ***
-(void)requestIndividalDetailtWith:(NSDictionary *)circle_Dic withBlock:(void (^)(ZSIndividualDetailModel *model,NSError *error))block;

#pragma mark **** 密码修改 ***
/**
 *  密码修改
 *
 *  @param userId 用户Id
 *  @param password     旧密码
 *  @param newPassword   新密码
 *  @param block     block
 */
-(void)requestEditPassword:(NSString *)userId
                      password:(NSString *)password
                    newPassword:(NSString*)newPassword
                      block:(void (^)(ZSModel* model, NSError* error))block;

@end
