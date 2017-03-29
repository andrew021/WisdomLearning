//
//  Study.h
//  WisdomLearning
//
//  Created by hfcb001 on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Study : NSObject

@end

@interface BannerList : NSObject

@property (nonatomic, copy) NSString *articleId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, assign) BOOL joined;
@property (nonatomic, copy) NSString *programId;
@property (nonatomic, copy) NSString *title;

@end

@interface LikeList : NSObject

@property (nonatomic, copy) NSString *objectId;
@property (nonatomic, copy) NSString *objectImage;
@property (nonatomic, assign) NSInteger objectType;
@property (nonatomic, copy) NSString *title;

@end

@interface TjCourseList : NSObject

@property (nonatomic, assign) long commentNum;
@property (nonatomic, copy) NSString *courseIcon;
@property (nonatomic, copy) NSString *courseId;
@property (nonatomic, copy) NSString *courseName;
@property (nonatomic, assign) long coursePrice;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, assign) long learnNum;
@property (nonatomic, assign) long rate;
@property (nonatomic, assign) long score;

@end

@interface TjNewsList : NSObject

@property (nonatomic, copy) NSString *newsIcon;
@property (nonatomic, copy) NSString *newsId;
@property (nonatomic, copy) NSString *newsSource;
@property (nonatomic, copy) NSString *newsTitle;
@property (nonatomic, copy) NSString *newsPubDateTime;

@end

@interface TjProgramList : NSObject

@property (nonatomic, copy) NSString *programIcon;
@property (nonatomic, copy) NSString *programId;
@property (nonatomic, copy) NSString *programName;
@property (nonatomic, copy) NSString *programSubject;

@end


//发现资讯
@interface DiscoveryInformation : NSObject

@property (nonatomic, copy) NSString *comFrom;//资讯出处
@property (nonatomic, copy) NSString *createDate;//发布时间
@property (nonatomic, copy) NSString *createUser;//作者
@property (nonatomic, copy) NSString *infoId;//资讯ID
@property (nonatomic, copy) NSString *img;//课学习圈缩略图 url
@property (nonatomic, assign) BOOL joined;// 是否加入
@property (nonatomic, copy) NSString *subject;//资讯简述
@property (nonatomic, copy) NSString *title;//资讯标题
@property (nonatomic, assign) long viewNum;//浏览量

@end

//专题详细
@interface TopicsDetails : NSObject

@property(nonatomic,copy) NSString *categoryName;//专题Name
@property(nonatomic,copy) NSString *certificateId;//获得证书ID
@property(nonatomic,copy) NSString *certificateName;//获得证书名称
@property(nonatomic,assign) long classCount;//项目班级数量
@property(nonatomic,copy) NSString *createTime;//创建时间
@property(nonatomic,copy) NSString *creater;//组织者
@property(nonatomic,copy) NSString *descr;//项目介绍
@property(nonatomic,assign) long finishedCoursesNum;//当前项目已经完成的课程数
@property(nonatomic,assign) BOOL finishedFlag;//项目是否完成
@property(nonatomic,assign) BOOL hascerted;//是否获得证书
@property(nonatomic,copy) NSString *icon;//培训缩略图
@property(nonatomic,copy) NSString *Id;//培训ID
@property(nonatomic,copy) NSString *image;//培训图片
@property(nonatomic,assign) long joinNum;//参加人数
@property(nonatomic,assign) BOOL learnFlag;
@property(nonatomic,copy) NSString *name;//培训名称
@property(nonatomic,copy) NSString *openEndTime;//开放时间止
@property(nonatomic,copy) NSString *openStartTime;//开放时间起
@property(nonatomic,assign) double price;//项目价格
@property(nonatomic,assign) CGFloat progress;//进度百分比0-1
@property(nonatomic,assign) long rank;
@property(nonatomic,assign) long rankType;
@property(nonatomic,assign) long remainCourseNums;//剩余课程数量
@property(nonatomic,assign) long scoreNeed;//毕业要求学分
@property(nonatomic,copy) NSString *createrAvater;//创建这头像
@property(nonatomic,assign) NSInteger totalStudytime;//总学习时间
@property(nonatomic,assign) long changeRank;//排名变化位数
@property(nonatomic,assign) long finishedScore;//完成学分
@property(nonatomic,assign) BOOL sign;//是否签到
@property(nonatomic,assign) BOOL isSigned;//是否签到
@property(nonatomic,assign) BOOL groupMember;
@property(nonatomic,strong) NSString * imgroupId;
@property(nonatomic,strong) NSString * shareUrl;
@end

//项目班级列表 （选班级与换班级）
@interface ClassList : NSObject

@property (nonatomic, copy) NSString *classId;//班级ID
@property (nonatomic, copy) NSString *className;//班级名称
@property (nonatomic, assign) NSInteger classType;//班级类型 1:面授班2:远程班
@property (nonatomic, assign) BOOL joinFlag;//是否参加
@property (nonatomic, assign) BOOL isViewFlag;//是否参加
@property (nonatomic, copy) NSString *signEndTime;//报名结束时间，用于报名前
@property (nonatomic, copy) NSString *signStartTime;//报名开始时间，用于报名前
@property (nonatomic, copy) NSString *studyEndTime;//报名结束时间，用于报名后
@property (nonatomic, copy) NSString *studyStartTime;//报名开始时间，用于报名后

@end

//首页数据
@interface HomePage : NSObject

@property(nonatomic, strong) NSArray <BannerList *> *bannerList;
@property(nonatomic, strong) NSArray <LikeList *> *likeList;
@property(nonatomic, strong) NSArray <TjCourseList *> *tjCourseList;
@property(nonatomic, strong) NSArray <TjNewsList *> *tjNewsList;
@property(nonatomic, strong) NSArray <TjProgramList *> *tjProgramList;

@end

//热门通知
@interface HotNotice : NSObject

@property (nonatomic, copy) NSString *comFrom;
@property (nonatomic, copy) NSString *createDate;
@property (nonatomic, copy) NSString *createUser;
@property (nonatomic, copy) NSString *Id;//新闻id
@property (nonatomic, copy) NSString *img;
@property (nonatomic, assign) BOOL joined;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *title;//通知标题
@property (nonatomic, assign) double viewNum;

@end

//学习提醒
@interface StudyMessageList : NSObject

//@property (nonatomic, copy) NSString *content;//提醒内容
//@property (nonatomic, copy) NSString *msgId;//提醒对象id
//@property (nonatomic, copy) NSString *msgTime;//消息时间
//@property (nonatomic, copy) NSString *msgType;//提醒业务类型，course：课程学习链接到课程学习页面；test：链接到测验页面；
//@property (nonatomic, copy) NSString *title;//提醒标题
//@property (nonatomic, copy) NSString *url;//提醒标题

@property (nonatomic, copy) NSString *objectId;//id
@property (nonatomic, copy) NSString *content;//提醒内容
@property (nonatomic, copy) NSString *senderId;//发送者id，为空就是系统发送的消息
@property (nonatomic, copy) NSString *courseId;//涉及到的课程id
@property (nonatomic, copy) NSString *clazzId;//涉及到的班级id
@property (nonatomic, copy) NSString *programId;//涉及到的专题id
@property (nonatomic, copy) NSString *newsId;//涉及到的新闻id
@property (nonatomic, copy) NSString *senderName;//发送者姓名，页面当senderId对应的user被删除后用这个显示页面
@property (nonatomic, copy) NSString *createTime;//创建时间
@property (nonatomic, copy) NSString *sendTime;//发送时间
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, copy) NSString *clazzType;//班级类型0：线上1：面授
@property (nonatomic, assign) BOOL readed;//是否阅读过
@property (nonatomic, copy) NSString *testUrl;//测验url
@property (nonatomic, copy) NSString *homeworkUrl;//作业url

@end

//用户学习信息(学习中心上部的个人信息)
@interface UserStudyinfo : NSObject

@property (nonatomic, assign) long certificateNum;//证书数量
@property (nonatomic, assign) long collectCourseNum;//收藏课程数量
@property (nonatomic, assign) long curClassNum;
@property (nonatomic, assign) long curLearnCourseNum;//在学课程数
@property (nonatomic, assign) long curProgramNum;
@property (nonatomic, assign) long finishClassNum;
@property (nonatomic, assign) long finishCourseNum;//学完课程数量
@property (nonatomic, assign) double learnCurrency;//学币
@property (nonatomic, assign) double learningScore;//在学学分
@property (nonatomic, assign) long mobileLearnTime;
@property (nonatomic, assign) long newNoticeNum;//新消息数
@property (nonatomic, copy) NSString *nickName;//用户昵称
@property (nonatomic, copy) NSString *telphone;//
@property (nonatomic, assign) long score;
@property (nonatomic, assign) long totalLearnTime;
@property (nonatomic, copy) NSString *userIcon;//用户头像
@property (nonatomic, copy) NSString *userId;//用户ID
@property (nonatomic, copy) NSString *userName;//用户名

@end

//学习中心
@interface StudyCenter : NSObject

@property (nonatomic, assign) BOOL hasSign;//是否已经签到

@property (nonatomic, copy) NSString *lastStudyCourseId;//最后学习课程id
@property (nonatomic, copy) NSString *lastStudyCourseName;//最后学习课程
@property (nonatomic, strong) NSMutableArray <HotNotice *> *newsList;//教育头条
@property (nonatomic, copy) NSString *signDesc;//签到说明
@property (nonatomic, strong) NSMutableArray <StudyMessageList *> *studyMessageList;//学习提醒消息

@end

//我参加的专题班级
@interface UserClassList : NSObject

@property (nonatomic, copy) NSString *classId;//班级ID
@property (nonatomic, copy) NSString *className;//班级名称
@property (nonatomic, copy) NSString *endTime;//结束时间
@property (nonatomic, copy) NSString *image;//图片
@property (nonatomic, copy) NSString *platform;//组织平台
@property (nonatomic, copy) NSString *projectName;//所属项目名称
@property (nonatomic, copy) NSString *startTime;//开始时间
@property (nonatomic, assign) NSInteger type;//班级类型2:面授 1：远程在线

@end

//远程班详细信息
@interface OnLineClassDetail : NSObject

@property (nonatomic, assign) long byDaies;//毕业天数
@property (nonatomic, copy) NSString *classEndTime;//班级结束时间
@property (nonatomic, copy) NSString *classId;//班级ID
@property (nonatomic, copy) NSString *className;//班级名称
@property (nonatomic, copy) NSString *classStartTime;//班级开始时间
@property (nonatomic, copy) NSString *clazzImg;//班级配图
@property (nonatomic, copy) NSString *fangURl;//关联的坊地址，暂时不用
@property (nonatomic, assign) long finishedCourseNum;//完成课程数量
@property (nonatomic, assign) double finishedScore;//获得学分
@property (nonatomic, assign) double finishedTime;//完成时间
@property (nonatomic, strong) NSMutableArray <HotNotice *> *hotNotice;
@property (nonatomic, copy) NSString *noticeListUrl;//通知url
@property (nonatomic, copy) NSString *noticeTitle;//通知标题
@property (nonatomic, copy) NSString *manager;//班主任
@property (nonatomic, assign) CGFloat progress;//班级进度，百分比 ，比如0.5
@property (nonatomic, assign) NSInteger rank;//排名
@property (nonatomic, assign) int rankUp;//排名升降1：up 2 ：down
@property (nonatomic, assign) double totalCourseNum;//总课程数量
@property (nonatomic, assign) double totalScore;//总学分
@property (nonatomic, copy) NSString *userAvatar;//头像
@property(nonatomic,assign) BOOL groupMember;
@property(nonatomic,strong) NSString * imgroupId;
@property (nonatomic, copy) NSString *programId;//专题Id
@property (nonatomic, assign) BOOL isSigned;
@property (nonatomic, copy) NSString *shareUrl;//

@end

//必/选修课表
@interface CourseList : NSObject


//add
@property(nonatomic, copy) NSString *courseType;
@property(nonatomic, assign) BOOL finishedFlag;
@property(nonatomic, assign) double learnCurrency;
@property(nonatomic, assign) double score;

@property (nonatomic, assign) BOOL onlined;//
@property (nonatomic, copy) NSString *courseEndTime;//
@property (nonatomic, copy) NSString *courseIcon;//培训课程缩略
@property (nonatomic, copy) NSString *courseId;//培训课程ID
@property (nonatomic, copy) NSString *courseName;//培训课程名称
@property (nonatomic, assign) long courseScore;//课程学分
@property (nonatomic, copy) NSString *courseStartTime;//
@property (nonatomic, copy) NSString *learnTime;//累计学习时间（单位秒）
@property (nonatomic, assign) CGFloat progress;//进度，百分比，100是复习，<100是绩效学习，0是开始学习
@property (nonatomic, copy) NSString *status;//

@end

@interface CheckList : NSObject

@property (nonatomic, copy) NSString *checkName;//项目名称
@property (nonatomic, assign) double maxcalculate;//实际成果最大计算值
@property (nonatomic, assign) double maxscore;//单项最大学分
@property (nonatomic, assign) double myScore;//我获得的学分
@property (nonatomic, copy) NSString *realRes;//实际成果
@property (nonatomic, copy) NSString *type;//类型
@property (nonatomic, copy) NSString *desc;//单项描述
@end

//远程班考核内容(远程班详细之考评要求)
@interface CheckreQuirements : NSObject

@property (nonatomic, strong) NSArray <CheckList *> *details;
@property (nonatomic, assign) double goodscore;//优良分数
@property (nonatomic, assign) double qualifiedscore;//合格分数
@property (nonatomic, assign) double score;//已获得分数
@property (nonatomic, assign) double totalscore;//总分
@property (nonatomic, strong) NSString *khDesc;//考核描述

@end

//各类组课程列表(远程班详细之课程学习)
@interface GroupCourseStudy : NSObject

//add
//"orignalPrice": 0,
//"programId": "6",
//"programName": "",
//"programPrice": 0,
//"programPriceDesc": "",
@property (nonatomic, copy) NSString *orignalPrice;//
@property (nonatomic, copy) NSString *programId;//
@property (nonatomic, copy) NSString *programName;//
@property (nonatomic, copy) NSString *programPrice;//
@property (nonatomic, copy) NSString *programPriceDesc;//
@property (nonatomic, assign) long aimCourseNum;//
@property (nonatomic, assign) long aimCourseScore;//
@property (nonatomic, copy) NSString *clazzId;//班级ID
@property (nonatomic, strong) NSMutableArray <CourseList *> *mustCourseList;//必修课表
@property (nonatomic, assign) long mustCourseNum;//必修课数量
@property (nonatomic, assign) long mustCourseScore;//必修课总学分

@property (nonatomic, strong) NSMutableArray <CourseList *> *selectCourseList;//选修课表
@property (nonatomic, assign) long selectCourseNum;//选修课数量
@property (nonatomic, assign) long selectCourseScore;//选修课总学分

@end

//测验列表
@interface TestWorkList : NSObject

@property (nonatomic, assign) BOOL finished;//是否测试完成 是否测试完成，已完成调整到测试结果页面
@property (nonatomic, copy) NSString *homeworkId;//测试ID
@property (nonatomic, copy) NSString *homeworkName;//测试名称
@property (nonatomic, assign) double score;//作业成绩
@property (nonatomic, copy) NSString *statusString;//状态文字
@property (nonatomic, assign) int status;
@property (nonatomic, copy) NSString *viewUrl;//作业

@property (nonatomic, copy) NSString *testId;//测试ID
@property (nonatomic, copy) NSString *testName;//测试名称
@property (nonatomic, copy) NSString *testUrl;//测试url
@property (nonatomic, copy) NSString *testResUrl;//测试结果url
@property (nonatomic, assign) long testNum;//测试次数
@property (nonatomic, assign) double testScore;//成绩
@property (nonatomic, copy) NSString *testTime;//测试用时
@property (nonatomic, assign) NSInteger hasTest;

@end

//远程班作业测试列表(远程班详细之作业测试)
@interface TestHomework : NSObject

@property (nonatomic, strong) NSMutableArray <TestWorkList *>  *homeworkList;//测验列表
@property (nonatomic, assign) long homeworkNum;//测验数量
@property (nonatomic, strong) NSMutableArray <TestWorkList *>  *testList;//测验列表
@property (nonatomic, assign) long testNum;//测验数量

@end

//签到
@interface Signup : NSObject

@property (nonatomic, copy)  NSString  *id;//签到记录id
@property (nonatomic, copy)  NSString  *signupTime; // 签到时间
@property (nonatomic, copy)  NSString  *location; // 签到地址
@property (nonatomic, copy)  NSString  *studentId;// 学生id
@property (nonatomic, copy)  NSString  *name;     // 学生姓名
@property (nonatomic, copy)  NSString  *courseId;//课程id
@property (nonatomic, copy)  NSString  *courseName;//课程名称

@end


//面授课程详情
@interface OfflineCourseDetail : NSObject

@property (nonatomic, copy) NSString *courseId; // 课程id
@property (nonatomic, copy) NSString *courseName; // 课程名称
@property (nonatomic, copy) NSString *courseIcon; // 课程缩略图
@property (nonatomic, copy) NSString *manager; // 主讲老师信息
@property (nonatomic, copy) NSString *descr; // 课程描述
@property (nonatomic, copy) NSString *category; // 类别
@property (nonatomic, copy) NSString *startDate;// 开始时间
@property (nonatomic, copy) NSString *endDate;// 结束时间
@property (nonatomic, copy) NSString *location;
@property (nonatomic, copy) NSString *homeworkDesc;//课程作业要求
@end

@interface ClassNoticeList : NSObject

@property (nonatomic, copy) NSString *noticeId; // 通知ID
@property (nonatomic, copy) NSString *title; // 通知标题
@property (nonatomic, copy) NSString *content; // 通知内容
@property (nonatomic, assign) BOOL joined; // 是否阅读

@end

@interface ProjectMetric : NSObject

@property (nonatomic, assign) BOOL isReg; // 是否报名

@end


