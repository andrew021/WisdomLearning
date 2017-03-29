//
//  ZSFindModel.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSFindModel.h"

@implementation ZSFindModel

@end

@implementation ZSFindListModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"pageData" : [CertificateListModel class] };
}

@end

@implementation ZSCertificateCourseListModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"mustCourseList" : [CertificateCourseModel class],@"selectCourseList":[CertificateCourseModel class]};
}


@end

@implementation ZSCerCourseListModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"data" : [CertificateCourseListModel class] };
}

@end
