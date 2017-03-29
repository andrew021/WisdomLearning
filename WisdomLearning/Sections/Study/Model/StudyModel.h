//
//  StudyModel.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"
#import "Study.h"

@interface StudyModel : ZSModel

@end

//发现资讯
@interface DiscoveryInformationModel : ZSModel

@property(nonatomic, strong) NSArray <DiscoveryInformation *> *pageData;
@property (nonatomic, assign) int curPage;//返回数据的页码
@property (nonatomic, assign) int totalPages;//总的分页数

@end

//专题详细
@interface TopicsDetailsModel : ZSModel

@property (nonatomic, strong)TopicsDetails *data;

@end

//项目班级列表 （选班级与换班级）
@interface ClassListModel : ZSModel

@property (nonatomic, strong)NSArray <ClassList *> *data;

@end

//用户学习信息(学习中心上部的个人信息)
@interface UserStudyinfoModel : ZSModel

@property (nonatomic, strong) UserStudyinfo *data;

@end

//学习中心
@interface StudyCenterModel : ZSModel

@property (nonatomic, strong) StudyCenter *data;

@end

//首页数据
@interface HomePageModel : ZSModel

@property (nonatomic, strong) HomePage *data;

@end

//我参加的专题班级
@interface UserClassListModel : ZSModel

@property (nonatomic, strong) NSArray <UserClassList *>*pageData;
@property (nonatomic, assign) long totalPages;//总的分页数
@property (nonatomic, assign) long curPage;//返回数据的页码

@end

//远程班详细信息
@interface OnLineClassDetailModel : ZSModel

@property (nonatomic, strong) OnLineClassDetail *data;

@end


@interface OfflineCourseListModel : ZSModel
@property (nonatomic, assign) long totalPages;//总的分页数
@property (nonatomic, assign) long curPage;//返回数据的页码
@property (nonatomic, assign) long totalRecords;
@property (nonatomic, assign) long perPage;
@property (nonatomic, strong) NSArray <CourseList *>*data;
@end

//远程班考核内容(远程班详细之考评要求)
@interface CheckreQuirementsModel : ZSModel

@property (nonatomic,strong) CheckreQuirements *data;

@end

//各类组课程列表(远程班详细之课程学习)
@interface GroupCourseStudyModel : ZSModel

@property (nonatomic, strong)GroupCourseStudy *data;

@end

//远程班作业测试列表(远程班详细之作业测试)
@interface TestHomeworkModel : ZSModel

@property (nonatomic, strong) TestHomework *data;

@end

// 签到列表
@interface ZSSignupListModel : ZSModel

@property (nonatomic, assign) long perPage;
@property (nonatomic, assign) long totalPages;
@property (nonatomic, assign) long totalRecords;
@property (nonatomic, assign) long curPage;
@property (nonatomic, strong) NSArray <Signup *>*pageData;

@end

@interface ZSOfflineCourseDetailModel : ZSModel

@property (nonatomic, strong) OfflineCourseDetail *data;

@end


@interface ClassNoticeListModel : ZSModel

@property (nonatomic, assign) long totalPages;
@property (nonatomic, strong) NSArray <ClassNoticeList *>*pageData;

@end

@interface ProjectMetricModel : ZSModel

@property (nonatomic, strong) ProjectMetric *data;

@end

