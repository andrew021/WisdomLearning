//
//  ZSRequest+Mine.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/7.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+Mine.h"

@implementation ZSRequest (Mine)

#pragma mark --- 学习系统-我的租户子站列表(我的应用)
- (void)requestMyTenantListWithDic:(NSDictionary *)dic block:(void (^)(MyTenantListModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"myTenantList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [MyTenantListModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((MyTenantListModel *)model,error);
        }
    }];
}

#pragma mark ---- 学习系统-我获得的证书列表
- (void)requestMyCertificateListWithDic:(NSDictionary *)dic block:(void (^)(MyCertificateListModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"myCertificateList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [MyCertificateListModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((MyCertificateListModel *)model,error);
        }
    }];
}

#pragma mark --- 学习系统-我的资讯列表
-(void)requestMyNewsListWithdic:(NSDictionary *)dic block:(void (^)(DiscoveryInformationModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"myNewsList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [DiscoveryInformationModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((DiscoveryInformationModel *)model,error);
        }
    }];
}

#pragma mark --- 学习系统-我的订单列表
-(void)requestMyOrderformListWithdic:(NSDictionary *)dic block:(void (^)(MyOrderformListModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"myOrderformList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [MyOrderformListModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((MyOrderformListModel *)model,error);
        }
    }];
}

@end
