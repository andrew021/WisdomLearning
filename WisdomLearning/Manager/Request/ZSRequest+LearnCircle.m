//
//  ZSRequest+LearnCircle.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+LearnCircle.h"

@implementation ZSRequest (LearnCircle)

#pragma mark ****  学习圈列表接口 ***
-(void)requestLearnCircleListWith:(NSDictionary *)circle_Dic withBlock:(void (^)(ZSLearnCircleModel *model,NSError *error))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"searchCircleList.action";
    if (circle_Dic) {
        [requestModel.requestParams addEntriesFromDictionary:circle_Dic];
    }
    requestModel.modelClass = [ZSLearnCircleModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSLearnCircleModel *)model, error);
        }
    }];
}

#pragma mark ****  同学录列表接口 ***
-(void)requestClassMateListWith:(NSDictionary *)circle_Dic withBlock:(void (^)(ZSClassMateModel *model,NSError *error))block{
    
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"groupStudentList.action";
    if (circle_Dic) {
        [requestModel.requestParams addEntriesFromDictionary:circle_Dic];
    }
    requestModel.modelClass = [ZSClassMateModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSClassMateModel *)model, error);
        }
    }];

}

#pragma mark ****  咨询详细接口 ***
-(void)requestInfoDetailWithDic:(NSDictionary *)dic
                          block:(void (^)(InfoModel *model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"articleDetail.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [InfoModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((InfoModel *)model,error);
        }
    }];
}


#pragma mark ****  搜索关键字接口 ***
-(void)requestSearchKeyWithDic:(NSDictionary *)dic
                         block:(void (^)(ZSSearchKeyModel *model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"mySearchKeys.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSSearchKeyModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSSearchKeyModel *)model,error);
        }
    }];

}

#pragma mark **** 添加搜索关键字接口  ***
-(void)requestAddSearchKey:(NSDictionary*)dic
                     block:(void (^)(ZSModel* model, NSError* error))block
{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"addSearchWord.action";
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

#pragma mark **** 我的学分接口 ***
-(void)requestMyCreditWithDic:(NSDictionary*)dic
                        block:(void (^)(ZSMyCreditModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"userlearnScoreList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSMyCreditModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSMyCreditModel *)model,error);
        }
    }];

}

#pragma mark **** 测验结果接口 ***
-(void)requestWorkTestResultWithDic:(NSDictionary*)dic
                              block:(void (^)(ZSWorkTestResultModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"saveOnlineTest.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSWorkTestResultModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSWorkTestResultModel *)model,error);
        }
    }];

}

#pragma mark **** 测验接口 ***
-(void)requestWorkTestWithDic:(NSDictionary*)dic
                        block:(void (^)(ZSWorkTestPaperModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"onlineTestDetail.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSWorkTestPaperModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSWorkTestPaperModel *)model,error);
        }
    }];

}

#pragma mark **** 发布资讯 ***
-(void)requestAddInfoWithDic:(NSDictionary*)dic
                       block:(void (^)(ZSModel* model, NSError* error))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"saveNews.action";
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

#pragma mark **** 我的学币接口 ***
-(void)requestMyCurrencyWithDic:(NSDictionary*)dic
                          block:(void (^)(ZSMyCreditModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"myLearnCurrencyList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSMyCreditModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSMyCreditModel *)model,error);
        }
    }];
}

#pragma mark **** 新鲜事接口 ***
-(void)requestNewThingWithDic:(NSDictionary*)dic
                        block:(void (^)(ZSNewThingrModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"freshList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSNewThingrModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSNewThingrModel *)model,error);
        }
    }];
}

#pragma mark **** 系统配置 ***
-(void)requesSystemSetWithDict:(NSDictionary *)dict Block:(void (^)(ZSSystemSetModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"sysConfig.action";
   
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSSystemSetModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSSystemSetModel *)model,error);
        }
    }];
}

#pragma mark **** 系统消息 ***
-(void)requesSystemMsgWithDict:(NSDictionary *)dict Block:(void (^)(ZSSystemMsgModel* model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"appMsgs.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSSystemMsgModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSSystemMsgModel *)model,error);
        }
    }];
}
@end
