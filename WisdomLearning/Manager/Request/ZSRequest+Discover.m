//
//  ZSRequest+Discover.m
//  WisdomLearning
//
//  Created by Shane on 16/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+Discover.h"

@implementation ZSRequest (Discover)


#pragma mark **** 自学选课 ***
-(void)requestCourseListWithData:(NSDictionary *)dict withBlock:(void (^)(ZSCurriculumModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"searchCourseList.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSCurriculumModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSCurriculumModel *)model, error);
        }
    }];
}


#pragma mark **** 线上课程详细信息 ***
-(void)requestOnlineCourseDetail:(NSDictionary *)dict withBlock:(void (^)(ZSOnlineCourseDetailModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"onlineCourseDetail.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSOnlineCourseDetailModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSOnlineCourseDetailModel *)model, error);
        }
    }];

}

#pragma mark **** 课程学习信息保存 ***
-(void)saveCousrseInfoWithData:(NSDictionary *)dict withBlock:(void (^)(ZSModel *model,NSError *error))block;{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"courseInfoSave.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSModel *)model, error);
        }
    }];
}

#pragma mark **** 专题课程接口 ***
-(void)requestProgramCourseList:(NSDictionary *)dict withBlock:(void (^)(GroupCourseStudyModel *model,NSError *error))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"programCourseList.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [GroupCourseStudyModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((GroupCourseStudyModel *)model, error);
        }
    }];
}

#pragma mark ****  发现证书列表接口 ***
-(void)requestCertificateListWith:(NSDictionary *)dic withBlock:(void (^)(ZSFindListModel *model,NSError *error))block{
    
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"searchCertList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSFindListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSFindListModel *)model, error);
        }
    }];
    
}

#pragma mark ****  证书课程列表接口 ***
-(void)requestCerCourseListWith:(NSDictionary *)dic withBlock:(void (^)(ZSCerCourseListModel *model,NSError *error))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"certCourseList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSCerCourseListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSCerCourseListModel *)model, error);
        }
    }];
}

#pragma mark ****  证书详细接口 ***
-(void)requestCerDetailWith:(NSDictionary *)dic withBlock:(void (^)(ZSFindListModel *model,NSError *error))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"certDetail.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSFindListModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSFindListModel *)model, error);
        }
    }];
}

#pragma mark **** 选课***
-(void)toChooseCourseWithDict:(NSDictionary *)dict withBlock:(void (^)(ZSModel *, NSError *))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"chooseCourse.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSModel *)model, error);
        }
    }];

}
@end
