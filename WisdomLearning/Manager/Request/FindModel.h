//
//  FindModel.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FindModel : NSObject

@end

//首页证书列表
@interface CertificateListModel : NSObject

@property (nonatomic,copy) NSString * certId; //ID
@property (nonatomic,copy) NSString * name; //证书名
@property (nonatomic,copy) NSString * img; //证书缩略图
@property (nonatomic,assign) long scoreNeed; //学分要求
@property (nonatomic,assign) long  mustScoreNeed; //必修
@property (nonatomic,assign) long  selectScoreNeed; //选修
@property (nonatomic,assign) long  minorScoreNeed; //辅修
@property (nonatomic,assign) long joinNum; //参加人数
@property (nonatomic,copy) NSString * certSubject; //证书简述
@property (nonatomic,copy) NSString * createTime; //发布时间

@property (nonatomic,copy) NSString * certificateName;//详细证书名

@end

////证书详细
//@interface CertificateDetailModel : NSObject
//
//@property (nonatomic,copy) NSString * certId; //ID
//@property (nonatomic,copy) NSString * certName; //证书名
//@property (nonatomic,copy) NSString * certIcon; //证书缩略图
//@property (nonatomic,copy) NSString * scoreNeed; //学分要求
//@property (nonatomic,copy) NSString * mustScoreNeed; //必修
//@property (nonatomic,copy) NSString * selectScoreNeed; //选修
//@property (nonatomic,copy) NSString * minorScoreNeed; //辅修
//@property (nonatomic,copy) NSString * joinNum; //参加人数
//@property (nonatomic,copy) NSString * certSubject; //证书简述
//@property (nonatomic,copy) NSString * createTime; //发布时间
//
//@end
@interface CertificateCourseModel : NSObject


//courseType = 2;
//finishedFlag = 0;
//learnCurrency = 1;
//learnTime = 0;

@property (nonatomic,copy) NSString * courseId; //ID
@property (nonatomic,copy) NSString * courseName; //课程名
@property (nonatomic,copy) NSString * contentOrder; //课程序号
@property (nonatomic,assign) long score; //学分要求
@property (nonatomic,copy) NSString * courseIcon;//课程图片
@end


//证书课程列表
@interface CertificateCourseListModel : NSObject

@property (nonatomic,copy) NSString * certId; //ID
@property (nonatomic,copy) NSString * certName; //证书名
//@property (nonatomic,copy) NSString * certIcon; //证书缩略图
//@property (nonatomic,copy) NSString * scoreNeed; //学分要求
@property (nonatomic,copy) NSString * mustScoreNeed; //必修
@property (nonatomic,copy) NSString * selectScoreNeed; //选修
@property (nonatomic,copy) NSString * minorScoreNeed; //辅修
//@property (nonatomic,copy) NSString * joinNum; //参加人数
//@property (nonatomic,copy) NSString * certSubject; //证书简述
//@property (nonatomic,copy) NSString * createTime; //发布时间
//@property (nonatomic,copy) NSArray *mustCourseList;
//@property (nonatomic,copy) NSArray *selectCourseList;
@property (nonatomic,copy) NSArray<CertificateCourseModel*>*mustCourseList;
@property (nonatomic,copy) NSArray<CertificateCourseModel*>*selectCourseList;
@property (nonatomic,copy) NSString * aimCourseDesc; //辅修说明

@end


