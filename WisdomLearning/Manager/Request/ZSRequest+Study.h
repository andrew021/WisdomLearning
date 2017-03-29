//
//  ZSRequest+Study.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSRequest.h"
#import "StudyModel.h"
#import "ZSMyCourseListModel.h"
//#import "ZSOfflineClassCourseInfo.h"
//#import "ZSOfflineCourseDetailInfo.h"

@interface ZSRequest (Study)

#pragma mark ****  首页专题列表接口 ***
-(void)requestSpecialListWith:(NSDictionary *)special_Dic withBlock:(void (^)(ZSLearnCircleModel *model,NSError *error))block;

/**
 *  学习系统-发现资讯
 *
 *  @param block        返回Block
 */
-(void)requestDiscoveryInformationWithDic:(NSDictionary *)dic
                                    block:(void (^)(DiscoveryInformationModel *model, NSError* error))block;

/**
 *  学习系统-培训项目详细信息(浏览和我的公用）
 *
 *  @param block        返回Block
 */
-(void)requestTopicsDetailsWithDic:(NSDictionary *)dic block:(void (^)(TopicsDetailsModel *model, NSError *error))block;

/**
 *  学习系统-项目班级列表（选班级与换班级）
 *
 *  @param block        返回Block
 */
-(void)requestProjectClassListWithDic:(NSDictionary *)dic block:(void (^)(ClassListModel *model, NSError *error))block;

/**
 *  学习系统-我参加的专题班级
 *
 *  @param block      返回Block
 */
-(void)requestUserClassListWithDic:(NSDictionary *)user_dic block:(void (^)(UserClassListModel *model, NSError *error))block;

/**
 *  学习系统-远程班详细信息
 *
 *  @param block      返回Block
 */
-(void)requestOnLineClassDetailWithUserDic:(NSDictionary *)user_dic block:(void (^)(OnLineClassDetailModel *model, NSError *error))block;

/**
 *  学习系统-学习中心
 *
 *  @param userId     用户ID
 *  @param block      返回Block
 */
-(void)requestStudyCenterWithDict:(NSDictionary *)dict block:(void (^)(StudyCenterModel *model, NSError *error))block;

/**
 *  学习系统-各类组课程列表(远程班详细之课程学习)
 *
 *  @param block      返回Block
 */
-(void)requestOnlineGroupCourseListWithDic:(NSDictionary *)dic block:(void (^)(GroupCourseStudyModel *model, NSError *error))block;

/**
 *  学习系统-用户学习信息接口(学习中心上部的个人信息)
 *
 *  @param userId   用户ID
 *  @param block    返回Block
 */
-(void)requestUserStudyinfoWithUserId:(NSString *)userId block:(void (^)(UserStudyinfoModel *model, NSError *error))block;

/**
 *  学习系统-获取远程班作业测试列表(远程班详细之作业测试)
 *
 *  @param block      返回Block
 */
-(void)requestOnlineClassTestHomeworkListWithDic:(NSDictionary *)dic block:(void (^)(TestHomeworkModel *model, NSError *error))block;

/**
 *  提交报名(免费情况下的报名)
 *
 *  @param block      返回Block
 */
-(void)requestProjectEnrollWithDic:(NSDictionary *)dic block:(void (^)(ZSModel *model, NSError *error))block;


/**
 *  学习系统-首页数据(发现首页)
 *
 *  @param block        返回Block
 */
-(void)requestHomePageUserId:(NSString *)userId block:(void (^)(HomePageModel *model, NSError *error))block;

/**
 *  学习系统-远程班详细信息(远程班详细之考评要求)
 *
 *  @param block      返回Block
 */
-(void)requestOnLineClassCheckWithdict:(NSDictionary *)dict block:(void (^)(CheckreQuirementsModel *model, NSError *error))block;




#pragma mark --- 用户课程列表---
-(void)requestMyCourseListWithDict:(NSDictionary *)dict block:(void (^)(ZSMyCourseListModel *model, NSError *error))block;

#pragma mark --- 面授班详细---
-(void)requestOffLineClassDetailWithDict:(NSDictionary *)dict block:(void (^)(OnLineClassDetailModel *model, NSError *error))block;

#pragma mark --- 面授班课程安排 ---
-(void)requestOffLineClassCourseListWithDict:(NSDictionary *)dict block:(void (^)(OfflineCourseListModel *model, NSError *error))block;
//
#pragma mark ---课程详细信息---
-(void)requestOffLineCourseDetailWithDict:(NSDictionary *)dict block:(void (^)(ZSOfflineCourseDetailModel *model, NSError *error))block;
//
#pragma mark --- 面授班级签到 ---
-(void)toSignUpOfflineClassWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block;

#pragma mark --- 签到记录 ---
-(void)requestSignupListWithDict:(NSDictionary *)dict block:(void (^)(ZSSignupListModel *model, NSError *error))block;


/**
 *  保存位置信息接口（用户经度纬度
 *
 *  @param block      返回Block
 */
-(void)requestSavePositionDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block;

/**
 *  班级公告
 *
 *  @param block      返回Block
 */
-(void)requestClassNoticeList:(NSDictionary *)dict block:(void (^)(ClassNoticeListModel *model, NSError *error))block;

/**
 *  报名中心
 *
 *  @param block      返回Block
 */
-(void)requestBmCenterList:(NSDictionary *)dict block:(void (^)(ZSLearnCircleModel *model, NSError *error))block;


/**
 *  判断是否参加项目
 *
 *  @param block      返回Block
 */
-(void)requestDetermineWhetherToParticipate:(NSDictionary *)dict block:(void (^)(ProjectMetricModel *model, NSError *error))block;
/**
 *  取消选课
 *
 *  @param dict
 *  @param block 
 */
-(void)cancelChooseCourseWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block;

/**
 *  换班级
 *
 *  @param dict
 *  @param block
 */
-(void)requestChangeClassWithDict:(NSDictionary *)dict block:(void (^)(ZSModel *model, NSError *error))block;


@end
