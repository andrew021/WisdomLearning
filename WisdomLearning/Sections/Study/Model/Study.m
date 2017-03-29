//
//  Study.m
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "Study.h"

@implementation Study

@end

@implementation BannerList

@end

@implementation LikeList

@end

@implementation TjCourseList

@end

@implementation TjNewsList

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"newsPubDateTime" : @"newPubDate",
             };
}

@end

@implementation TjProgramList

@end


//发现资讯
@implementation DiscoveryInformation

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"infoId" : @"id",
             };
}

@end

//专题详细
@implementation TopicsDetails

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"Id" : @"id",@"isSigned":@"signed"
             };
}

@end

//项目班级列表 （选班级与换班级）
@implementation ClassList


@end

//首页数据
@implementation HomePage

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"bannerList" : [BannerList class],
             @"likeList" : [LikeList class],
             @"tjCourseList" : [TjCourseList class],
             @"tjProgramList" : [TjProgramList class],
             @"tjNewsList" : [TjNewsList class],
             };
}

@end

//热门通知
@implementation HotNotice

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"Id" : @"id",
             };
}
@end

//学习提醒
@implementation StudyMessageList

@end

//用户学习信息(学习中心上部的个人信息)
@implementation UserStudyinfo

@end

//学习中心
@implementation StudyCenter

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"newsList":[HotNotice class],
              @"studyMessageList":[StudyMessageList class]
            };
}

@end

//我参加的专题班级
@implementation UserClassList

@end

//远程班详细信息
@implementation OnLineClassDetail

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"isSigned" : @"signed",
             };
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"hotNotice":[HotNotice class] };
}

@end

//必/选修课表
@implementation CourseList

@end

@implementation CheckList

@end


//远程班考核内容(远程班详细之考评要求)
@implementation CheckreQuirements

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"details":[CheckList class],
              };
}

@end

//各类组课程列表(远程班详细之课程学习)
@implementation GroupCourseStudy

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"mustCourseList":[CourseList class],
              @"selectCourseList":[CourseList class]
              };
}

@end

//测验列表
@implementation TestWorkList

@end

//远程班作业测试列表(远程班详细之作业测试)
@implementation TestHomework

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"homeworkList":[TestWorkList class],
              @"testList":[TestWorkList class]
              };
}

@end

@implementation Signup


@end

@implementation OfflineCourseDetail


@end

@implementation ClassNoticeList

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"noticeId" : @"id",
             };
}

@end

@implementation ProjectMetric

@end
