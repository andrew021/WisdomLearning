//
//  StudyModel.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "StudyModel.h"

@implementation StudyModel

@end

//发现资讯
@implementation DiscoveryInformationModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pageData" : [DiscoveryInformation class]};
}

@end

//专题详细
@implementation TopicsDetailsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [TopicsDetails class]};
}

@end

//项目班级列表 （选班级与换班级）
@implementation ClassListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ClassList class]};
}

@end

//用户学习信息(学习中心上部的个人信息)
@implementation UserStudyinfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [UserStudyinfo class]};
}

@end

//学习中心
@implementation StudyCenterModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [StudyCenter class]};
}

@end

//首页数据
@implementation HomePageModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [HomePage class]};
}

@end

//我参加的专题班级
@implementation UserClassListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pageData" : [UserClassList class]};
}

@end

@implementation OfflineCourseListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [CourseList class]};
}

@end

//远程班详细信息
@implementation OnLineClassDetailModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [OnLineClassDetail class]};
}

@end

//远程班考核内容(远程班详细之考评要求)
@implementation CheckreQuirementsModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [CheckreQuirements class]};
}

@end

//各类组课程列表(远程班详细之课程学习)
@implementation GroupCourseStudyModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [GroupCourseStudy class]};
}

@end

//远程班作业测试列表(远程班详细之作业测试)
@implementation TestHomeworkModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [TestHomework class]};
}

@end

@implementation ZSSignupListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pageData" : [Signup class]};
}

@end

@implementation ZSOfflineCourseDetailModel


@end

@implementation ClassNoticeListModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"pageData" : [ClassNoticeList class]};
}

@end

@implementation ProjectMetricModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"data" : [ProjectMetric class]};
}

@end

