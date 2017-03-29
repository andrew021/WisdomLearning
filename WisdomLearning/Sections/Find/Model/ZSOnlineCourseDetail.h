//
//  ZSOnlineCourseDetail.h
//  WisdomLearning
//
//  Created by Shane on 16/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZSChaptersInfo;
@class ZSLatestLearnChapterInfo;

@interface ZSOnlineCourseDetail : NSObject

//CourseDetailVO

@property(nonatomic, copy) NSString * courseId; // 课程id
@property(nonatomic, copy) NSString * courseName; // 课程名称
@property(nonatomic, copy) NSString * courseIcon; // 课程缩略图
@property(nonatomic, copy) NSString * tryReadUrl; // 试读url
@property(nonatomic, assign) BOOL learnFlag; // 是否学习该课
@property(nonatomic, copy) NSString * collectFlag; // 是否收藏该课
@property(nonatomic, copy) NSString * latestLearnTime; // 最后学习时间
@property(nonatomic, copy) NSString * lastChapterDesc;// 最后学习章节描述
@property(nonatomic, assign) double coursePrice; // 课程价格，空表示没有设置价格免费
@property(nonatomic, copy) NSString * orignalPrice;// 课程原价
@property(nonatomic, copy) NSString * learnNum; // 选课人数
@property(nonatomic, copy) NSString * rate; // 评论等级，空表示没有评论
@property(nonatomic, copy) NSString * commentNum; // 评论数
@property(nonatomic, copy) NSString * totalLearnTime; // 累计学习时间(单位秒)，空表示没有学习
@property(nonatomic, copy) NSString * appTotalLearnTime;// app累计学习时间(单位秒)
@property(nonatomic, copy) NSString * score; // 学分
@property(nonatomic, copy) NSString * courseModelType; // 课程模块类型，公需、专业，开放等
@property(nonatomic, copy) NSString * myScore; // 我的学分(如果调用参数有）
@property(nonatomic, copy) NSString * teacherInfo; // 主讲老师信息
@property(nonatomic, copy) NSString * courseDesc; // 课程描述
@property(nonatomic, copy) NSString * timeFinishCondition; // 学习时间条件，单位分钟
@property(nonatomic, copy) NSString * coverFinishCondition;// 覆盖率条件 单位百分比
@property(nonatomic, copy) NSString * scoreFinisCondition;// 课程成绩完成条件
@property(nonatomic, copy) NSString * courseFrom;// 来源
@property(nonatomic, copy) NSString * playNum;// 播放次数
@property(nonatomic, copy) NSString *testUrl;  //测试url
@property(nonatomic, copy) NSString *shareUrl;  //分享的url
@property(nonatomic, copy) NSString *qaUrl;  //在线答疑
@property (nonatomic, copy) NSString *testResUrl;//测试结果url
@property(nonatomic, assign) BOOL hasTest;  //是否有测验
@property(nonatomic, assign) BOOL needReward;  //是否需要打赏
@property(nonatomic, copy) NSString *testScore;  //测验分数
@property(nonatomic, strong) ZSLatestLearnChapterInfo * latestLearnChapter; // 最后学习章节
@property(nonatomic, copy) NSArray<ZSChaptersInfo *> * chapters; // 大纲(树形结构)

@end


@interface ZSChaptersInfo : NSObject

// StudentChaptersVO

@property(nonatomic, copy) NSString *chapterId;      // 章节ID
@property(nonatomic, copy) NSString *chapterName;    // 章节名称
@property(nonatomic, copy) NSString *chapterType;    // 章节类型
@property(nonatomic, copy) NSString *chapterOrder;   // 章节序号
@property(nonatomic, copy) NSString *breakPoint;     // 断点(调用时有userId参数才有)
@property(nonatomic, copy) NSString *learnTime;      // 学习时间(单位秒,调用时有userId参数才有)
@property(nonatomic, copy) NSString *parentChapterId;// 父章节ID
@property(nonatomic, copy) NSString *mobileLearnTime;// 移动学习时间(单位秒)
@property(nonatomic, copy) NSString *lastLearnTime;  // 最后学习时间
@property(nonatomic, copy) NSString *chapterDesc;    // 章节描述
@property(nonatomic, copy) NSString *resourceUrl;    // 资源
@property(nonatomic, copy) NSString *sfpDesc;        // 三分频定义
@property(nonatomic, copy) NSString *learnCoverRate; // 章节学习覆盖率
@property(nonatomic, copy) NSString *resType;    //课件类型字段：video,html,pptvideo
@property(nonatomic, copy) NSString *pptVideoUrl;
@property(nonatomic, copy) NSString *pptVideoIndex;    //返回ppt图片和视频时间对应关系，格式为s:ppt数组下标
@property(nonatomic, copy) NSArray<NSString *> *pptImgList;
@property(nonatomic, copy) NSString *htmlUrl;
@property(nonatomic, assign) BOOL isFinished;



@end

@interface ZSLatestLearnChapterInfo : NSObject

//BreakPointLearnCharpterVO
@property(nonatomic, copy) NSString *chapterId;     // 最后学习章节ID
@property(nonatomic, copy) NSString *chapterName;   // 最后学习章节名称
@property(nonatomic, copy) NSString *chapterType;   // 章节资源类型，视频还是其他
@property(nonatomic, copy) NSString *resourceUrl;   // 课件资源url
@property(nonatomic, copy) NSString *breakPoint;    // 断点

@end

@interface ZSChapterSaveInfo : NSObject

//chapterId
//mobileLearnTime
//breakPoint
//lastLearnTime

@property(nonatomic, copy) NSString *chapterId;
@property(nonatomic, copy) NSString *mobileLearnTime;
@property(nonatomic, copy) NSString *breakPoint;
@property(nonatomic, copy) NSString *lastLearnTime;

@end