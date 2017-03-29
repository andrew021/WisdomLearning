//
//  ZSRequest+Study.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest+Study.h"

@implementation ZSRequest (Study)

#pragma mark ****  首页专题列表接口 ***
-(void)requestSpecialListWith:(NSDictionary *)special_Dic withBlock:(void (^)(ZSLearnCircleModel *model,NSError *error))block{
    ZSRequestModel* requestModel = [ZSRequestModel new];
    requestModel.requestName = @"searchProgramList.action";
    if (special_Dic) {
        [requestModel.requestParams addEntriesFromDictionary:special_Dic];
    }
    requestModel.modelClass = [ZSLearnCircleModel  class];
    [self requestWithModel:requestModel block:^(ZSModel* model, NSError* error) {
        if (block) {
            block((ZSLearnCircleModel *)model, error);
        }
    }];
}

        
#pragma mark --- 学习系统-发现资讯
-(void)requestDiscoveryInformationWithDic:(NSDictionary *)dic block:(void (^)(DiscoveryInformationModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"searchNewsList.action";
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

#pragma mark --- 学习系统-培训项目详细信息(浏览和我的公用）
-(void)requestTopicsDetailsWithDic:(NSDictionary *)dic block:(void (^)(TopicsDetailsModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"programDetail.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [TopicsDetailsModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((TopicsDetailsModel *)model,error);
        }
    }];
}

#pragma mark --- 学习系统-项目班级列表（选班级与换班级）
- (void)requestProjectClassListWithDic:(NSDictionary *)dic block:(void (^)(ClassListModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"projectClassList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ClassListModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ClassListModel *)model,error);
        }
    }];
}

#pragma mark ---- 学习系统-我参加的专题班级
-(void)requestUserClassListWithDic:(NSDictionary *)user_dic block:(void (^)(UserClassListModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"myClassList.action";
    if (user_dic) {
        [requestModel.requestParams addEntriesFromDictionary:user_dic];
    }
    requestModel.modelClass = [UserClassListModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((UserClassListModel *)model,error);
        }
    }];
}

#pragma mark --- 学习系统-远程班详细信息
-(void)requestOnLineClassDetailWithUserDic:(NSDictionary *)user_dic block:(void (^)(OnLineClassDetailModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"onLineClassDetail.action";
    if (user_dic) {
        [requestModel.requestParams addEntriesFromDictionary:user_dic];
    }
    requestModel.modelClass = [OnLineClassDetailModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((OnLineClassDetailModel *)model,error);
        }
    }];
}

#pragma mark --- 学习系统-学习中心
-(void)requestStudyCenterWithDict:(NSDictionary *)dict block:(void (^)(StudyCenterModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"userStudyCenterList.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [StudyCenterModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((StudyCenterModel *)model,error);
        }
    }];
}

#pragma marek ---- 学习系统-各类组课程列表(远程班详细之课程学习)
-(void)requestOnlineGroupCourseListWithDic:(NSDictionary *)dic block:(void (^)(GroupCourseStudyModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"onlineGroupCourseList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [GroupCourseStudyModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((GroupCourseStudyModel *)model,error);
        }
    }];
}

#pragma mark --- 学习系统-用户学习信息接口(学习中心上部的个人信息)
- (void)requestUserStudyinfoWithUserId:(NSString *)userId block:(void (^)(UserStudyinfoModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"userStudyinfo.action";
    if (userId) {
        [requestModel.requestParams setValue:userId forKey:@"userId"];
    }
    requestModel.modelClass = [UserStudyinfoModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((UserStudyinfoModel *)model,error);
        }
    }];
}

#pragma mark --- 学习系统-获取远程班作业测试列表(远程班详细之作业测试)
-(void)requestOnlineClassTestHomeworkListWithDic:(NSDictionary *)dic block:(void (^)(TestHomeworkModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"onlineGroupTestHomeworkList.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [TestHomeworkModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((TestHomeworkModel *)model,error);
        }
    }];
}

#pragma mark --- 提交报名(免费情况下的报名)
- (void)requestProjectEnrollWithDic:(NSDictionary *)dic block:(void (^)(ZSModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"projectEnroll.action";
    if (dic) {
        [requestModel.requestParams addEntriesFromDictionary:dic];
    }
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block(model,error);
        }
    }];
}

#pragma mark --- 学习系统-首页数据(发现首页)
- (void)requestHomePageUserId:(NSString *)userId block:(void (^)(HomePageModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"studyappindex.action";
    if (userId) {
        [requestModel.requestParams setValue:userId forKey:@"userId"];
    }
    requestModel.modelClass = [HomePageModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((HomePageModel *)model,error);
        }
    }];
}

#pragma mark --- 学习系统-远程班详细信息(远程班详细之考评要求)
-(void)requestOnLineClassCheckWithdict:(NSDictionary *)dict block:(void (^)(CheckreQuirementsModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"onLineClassCheck.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [CheckreQuirementsModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((CheckreQuirementsModel *)model,error);
        }
    }];
}



#pragma mark --- 用户课程列表---
-(void)requestMyCourseListWithDict:(NSDictionary *)dict block:(void (^)(ZSMyCourseListModel *, NSError *))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"myCourseList.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSMyCourseListModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSMyCourseListModel *)model,error);
        }
    }];
}


#pragma mark --- 面授班详细---
-(void)requestOffLineClassDetailWithDict:(NSDictionary *)dict block:(void (^)(OnLineClassDetailModel *, NSError *))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"offLineClassDetail.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [OnLineClassDetailModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((OnLineClassDetailModel *)model,error);
        }
    }];
}
//
#pragma mark --- 面授班课程安排 ---
-(void)requestOffLineClassCourseListWithDict:(NSDictionary *)dict block:(void (^)(OfflineCourseListModel *, NSError *))block{
        ZSRequestModel *requestModel = [ZSRequestModel new];
        requestModel.requestName = @"offLineClassCourseList.action";
        if (dict) {
            [requestModel.requestParams addEntriesFromDictionary:dict];
        }
        requestModel.modelClass = [OfflineCourseListModel class];
        [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
            if (block) {
                block((OfflineCourseListModel *)model,error);
            }
        }];
}

#pragma mark ---课程详细信息---
-(void)requestOffLineCourseDetailWithDict:(NSDictionary *)dict block:(void (^)(ZSOfflineCourseDetailModel *, NSError *))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"offlineCourseDetail.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSOfflineCourseDetailModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSOfflineCourseDetailModel *)model,error);
        }
    }];
}
//
#pragma mark --- 面授班级签到 ---
-(void)toSignUpOfflineClassWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *, NSError *))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"saveSignup.action";
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

#pragma mark --- 签到记录 ---
-(void)requestSignupListWithDict:(NSDictionary *)dict block:(void (^)(ZSSignupListModel *, NSError *))block{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"signupList.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSSignupListModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSSignupListModel *)model,error);
        }
    }];

}

#pragma mark ---  保存位置信息接口（用户经度纬度）
-(void)requestSavePositionDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"savePosition.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block(model,error);
        }
    }];
}

#pragma mark ---  班级公告
-(void)requestClassNoticeList:(NSDictionary *)dict block:(void (^)(ClassNoticeListModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"classNoticeList.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ClassNoticeListModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ClassNoticeListModel *)model,error);
        }
    }];
}

#pragma mark --- 报名中心
-(void)requestBmCenterList:(NSDictionary *)dict block:(void (^)(ZSLearnCircleModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"bmProjectList.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSLearnCircleModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ZSLearnCircleModel *)model,error);
        }
    }];
}

#pragma mark --- 判断是否参加项目
-(void)requestDetermineWhetherToParticipate:(NSDictionary *)dict block:(void (^)(ProjectMetricModel *model, NSError *error))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"verifyreg.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ProjectMetricModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block((ProjectMetricModel *)model,error);
        }
    }];
}

#pragma mark ---  取消选课
-(void)cancelChooseCourseWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"cancelChooseCourse.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block(model,error);
        }
    }];
}

#pragma mark --- 换班级
-(void)requestChangeClassWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *, NSError *))block
{
    ZSRequestModel *requestModel = [ZSRequestModel new];
    requestModel.requestName = @"changeclazz.action";
    if (dict) {
        [requestModel.requestParams addEntriesFromDictionary:dict];
    }
    requestModel.modelClass = [ZSModel class];
    [self requestWithModel:requestModel block:^(ZSModel *model, NSError *error) {
        if (block) {
            block(model,error);
        }
    }];
}

@end
