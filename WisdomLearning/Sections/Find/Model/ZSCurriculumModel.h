//
//  ZSCurriculumModel.h
//  WisdomLearning
//
//  Created by Shane on 16/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"

@class ZSCurriculumInfo ;
@interface ZSCurriculumModel : ZSModel

//curPage	返回数据的页码
//perPage	每页记录数
//totalRecords	总的符合条件的记录数
//totalPages	总的分页数
//conditions	查询条件
//pageData	查询返回的课程内容

@property(nonatomic, assign) long curPage;
@property(nonatomic, copy) NSString *perPage;
@property(nonatomic, assign) long totalRecords;
@property(nonatomic, assign) long totalPages;
@property(nonatomic, copy) NSString *conditions;
@property(nonatomic, copy) NSArray<ZSCurriculumInfo *> *pageData;

@end


@interface ZSCurriculumInfo : NSObject
//  CourseVO.java

@property(nonatomic, copy) NSString *courseId;
@property(nonatomic, copy) NSString *courseName;  //课程名称
@property(nonatomic, copy) NSString *courseIcon;  // 培训课程缩略图
@property(nonatomic, assign) double coursePrice; // 课程价格（学币）
@property(nonatomic, copy) NSString *learnNum;    // 累计学习人次
@property(nonatomic, assign) int rate;        // 评论等级
@property(nonatomic, copy) NSString *commentNum;  // 评论数量
@property(nonatomic, copy) NSString *createTime;  // 发布时间
@property(nonatomic, copy) NSString *score;       //学分
@property(nonatomic, copy) NSString *cats;       //分类
@property(nonatomic, copy) NSString *chapterNum;       //节数
@property(nonatomic, assign) BOOL learned;   //是否已经学习
@property(nonatomic, copy) NSString *finishedPercent;// 完成百分比
@property(nonatomic, copy) NSString *remindTime ;//剩余时间


@end
