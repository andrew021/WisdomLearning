//
//  ZSRequest+Discover.h
//  WisdomLearning
//
//  Created by Shane on 16/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "ZSCurriculumModel.h"
#import "ZSOnlineCourseDetailModel.h"
#import "ZSFindModel.h"
#import "ZSProgramCourseListModel.h"
#import "StudyModel.h"


@interface ZSRequest (Discover)


#pragma mark **** 自学选课 ***
-(void)requestCourseListWithData:(NSDictionary *)dict withBlock:(void (^)(ZSCurriculumModel *model,NSError *error))block;

#pragma mark **** 线上课程详细信息 ***
-(void)requestOnlineCourseDetail:(NSDictionary *)dict withBlock:(void (^)(ZSOnlineCourseDetailModel *model,NSError *error))block;

#pragma mark **** 课程学习信息保存 ***
-(void)saveCousrseInfoWithData:(NSDictionary *)dict withBlock:(void (^)(ZSModel *model,NSError *error))block;

#pragma mark **** 选课***
-(void)toChooseCourseWithDict:(NSDictionary *)dict withBlock:(void (^)(ZSModel *model,NSError *error))block;


#pragma mark **** 专题课程接口 ***
-(void)requestProgramCourseList:(NSDictionary *)dict withBlock:(void (^)(GroupCourseStudyModel *model,NSError *error))block;

#pragma mark ****  发现证书列表接口 ***
-(void)requestCertificateListWith:(NSDictionary *)dic withBlock:(void (^)(ZSFindListModel *model,NSError *error))block;


#pragma mark ****  证书课程列表接口 ***
-(void)requestCerCourseListWith:(NSDictionary *)dic withBlock:(void (^)(ZSCerCourseListModel *model,NSError *error))block;

#pragma mark ****  证书详细接口 ***
-(void)requestCerDetailWith:(NSDictionary *)dic withBlock:(void (^)(ZSFindListModel *model,NSError *error))block;

@end
