//
//  ZSMyCourseInfo.h
//  WisdomLearning
//
//  Created by Shane on 16/11/4.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSModel.h"

@interface ZSMyCourseInfo : NSObject

//MyCourseVO

@property(nonatomic, copy) NSString * courseId; // 课程id
@property(nonatomic, copy) NSString * courseName; // 课程名称
@property(nonatomic, copy) NSString * courseIcon; // 课程缩略图
@property(nonatomic, copy) NSString * coursePrice;// 课程价格
@property(nonatomic, copy) NSString * learnNum;// 学习人数
@property(nonatomic, copy) NSString * rate; // 评论等级
@property(nonatomic, copy) NSString * commentNum; // 评论数量
@property(nonatomic, copy) NSString * totalLearnTime;// 累计学习时间(单位秒)
@property(nonatomic, copy) NSString * finishedPercent;// 完成百分比
@property(nonatomic, copy) NSString * needFinishedTime;// 要求完成时间(单位秒)
@property(nonatomic, copy) NSString * finishedTime; //完成时间
@property(nonatomic, copy) NSString * courseScore;// 课程学分
@property(nonatomic, copy) NSString * remindTime ;//剩余时间
@property(nonatomic, copy) NSString * clazzId ;//班级Id


@end

@interface ZSMyCourseListModel : ZSModel

//curPage	返回数据的页码
//perPage	每页记录数
//totalRecords	总的符合条件的记录数
//totalPages	总的分页数
//conditions	查询条件
//sortby	排序条件
//pageData	查询返回的课程内容

@property(nonatomic, assign) long curPage;
@property(nonatomic, assign) long perPage;
@property(nonatomic, assign) long totalRecords;
@property(nonatomic, assign) long totalPages;
@property(nonatomic, copy) NSString *conditions;
@property(nonatomic, copy) NSString *sortby;
@property(nonatomic, copy) NSArray<ZSMyCourseInfo *> *pageData;

@end
