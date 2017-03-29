//
//  ZSRequest+Pay.m
//  WisdomLearning
//
//  Created by Shane on 16/11/9.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+Pay.h"

@implementation ZSRequest (Pay)


#pragma mark  --请求生成的阿里订单信息--
-(void)requestAliPayOrderWithDict:(NSDictionary *)dict block:(void (^)(ZSPayOrderModel *, NSError *))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"genOrderformAli.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSPayOrderModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSPayOrderModel *)model,error);
        }
    }];
}

#pragma mark  --请求生成的微信支付订单信息--
-(void)requestWxPayOrderWithDict:(NSDictionary *)dict block:(void (^)(ZSPayOrderModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"genOrderformWX.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSPayOrderModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSPayOrderModel *)model,error);
        }
    }];
}

#pragma mark  --请求生成的银联支付订单信息--
-(void)requestUnionPayOrderWithDict:(NSDictionary *)dict block:(void (^)(ZSPayOrderModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"genOrderformUnion.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSPayOrderModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSPayOrderModel *)model,error);
        }
    }];

}

#pragma mark  --提交支付订单信息给后台--
-(void)postServerWithPayDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"paySuccessForClient.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSModel *)model,error);
        }
    }];

}


@end
