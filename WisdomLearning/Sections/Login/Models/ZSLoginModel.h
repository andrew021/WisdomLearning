//
//  ZSLoginModel.h
//  WisdomLearning
//
//  Created by Shane on 16/11/1.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"

@class ZSLoginInfo;
@interface ZSLoginModel : ZSModel

@property (nonatomic, strong) ZSLoginInfo *data;

@end



@interface ZSLoginInfo : NSObject<NSCoding>

@property(nonatomic, copy) NSString *userId;
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *nickName; // 用户昵称
@property(nonatomic, copy) NSString *userIcon; // 用户头像
@property(nonatomic, copy) NSString *mobileLearnTime; // 移动学习时间(单位秒)
@property(nonatomic, copy) NSString *totalLearnTime;  // 总学习时间（单位秒）
@property(nonatomic, copy) NSString *score; // 学分
@property(nonatomic, copy) NSString *learningScore; // 在学学分
@property(nonatomic, copy) NSString *certificateNum;  // 证书数
@property(nonatomic, copy) NSString *learnCurrency;   // 学币

@property(nonatomic, copy) NSString *curLearnCourseNum; // 在学课程数
@property(nonatomic, copy) NSString *curClassNum;     // 当前培训班级数
@property(nonatomic, copy) NSString *curProgramNum;     // 当前培训数
@property(nonatomic, copy) NSString *collectCourseNum;  // 收藏课程数量
@property(nonatomic, copy) NSString *finishCourseNum;   // 学完课程
@property(nonatomic, copy) NSString *finishClassNum;    // 学完班级数量

@property(nonatomic, copy) NSString *noticeNum;    // 消息数


@end
