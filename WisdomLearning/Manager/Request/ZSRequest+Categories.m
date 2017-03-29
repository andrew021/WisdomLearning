//
//  ZSRequest+Categories.m
//  WisdomLearning
//
//  Created by Shane on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+Categories.h"

@implementation ZSRequest (Categories)

-(void)requestCategoriesListNumberWithBlock:(void (^)(ZSCategoryListModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"courseCategorys.action";
    requestModel.modelClass = [ZSCategoryListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSCategoryListModel *)model, error);
        }
    }];

}

#pragma mark --- 学习系统-资讯分类
- (void)requestNewsCategoryBlock:(void (^)(ZSCategoryListModel *, NSError *))block
{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"newsCategorys.action";
    requestModel.modelClass = [ZSCategoryListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSCategoryListModel *)model, error);
        }
    }];
}

-(void)requestIntelligentOrderWithType:(NSString*)type WithBlock:(void (^)(ZSIntelligentOrderModel *model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"orderFields.action";
    if (type) {
        [requestModel.requestParams setObject:type forKey:@"type"];
    }
    requestModel.modelClass = [ZSIntelligentOrderModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSIntelligentOrderModel *)model,error);
        }
    }];
}

-(void)requestFilterFieldWithType:(NSString*)type WithBlock:(void (^)(ZSFilterFieldModel *model, NSError* error))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"filterFields.action";
    if (type) {
        [requestModel.requestParams setObject:type forKey:@"type"];
    }
    requestModel.modelClass = [ZSFilterFieldModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSFilterFieldModel *)model,error);
        }
    }];
}
@end
