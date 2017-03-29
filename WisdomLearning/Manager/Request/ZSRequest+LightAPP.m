//
//  ZSRequest+LightAPP.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+LightAPP.h"

@implementation ZSRequest (LightAPP)

#pragma mark **** 轻应用全部列表接口 ***
-(void)requestAllLightAppListWithDic:(NSDictionary*)dic
                               block:(void (^)(ZSLightAppModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"appList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSLightAppModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSLightAppModel *)model,error);
        }
    }];

}

#pragma mark **** 添加或删除轻应用接口 ***
-(void)requestAddOrReduceLightAppWithDic:(NSDictionary*)dic
                                   block:(void (^)(ZSModel* model, NSError* error))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"saveMyApp.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block(model, error);
        }
    }];

}

#pragma mark **** 我的轻应用全部列表接口 ***
-(void)requestMyLightAppListWithDic:(NSDictionary*)dic
                              block:(void (^)(ZSLightAppModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"myAppList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSLightAppModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSLightAppModel *)model,error);
        }
    }];
}
@end
