//
//  ZSFindModel.h
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSModel.h"
#import "FindModel.h"

@interface ZSFindModel : ZSModel

@end

@interface ZSFindListModel : ZSModel

@property (nonatomic, strong) NSArray<CertificateListModel*>* pageData;
@property (nonatomic, assign) NSInteger curPage;
@property (nonatomic, assign) NSInteger totalPages;
@property (nonatomic, strong) CertificateListModel * data;

@end

//证书课程列表
@interface ZSCertificateCourseListModel : ZSModel

@property (nonatomic,copy) NSString * certId; //ID
@property (nonatomic,copy) NSString * certName; //证书名
@property (nonatomic,copy) NSString * mustScoreNeed; //必修
@property (nonatomic,copy) NSString * selectScoreNeed; //选修
@property (nonatomic,copy) NSString * minorScoreNeed; //辅修
@property (nonatomic,copy) NSArray<CertificateCourseModel*>*mustCourseList;
@property (nonatomic,copy) NSArray<CertificateCourseModel*>*selectCourseList;
@property (nonatomic,copy) NSString * aimCourseDesc; //辅修说明

@end


@interface ZSCerCourseListModel : ZSModel

@property (nonatomic, strong) ZSCertificateCourseListModel* data;

@end

