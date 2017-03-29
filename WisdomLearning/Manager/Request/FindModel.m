//
//  FindModel.m
//  WisdomLearning
//
//  Created by DiorSama on 2016/11/2.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "FindModel.h"

@implementation FindModel

@end

@implementation CertificateListModel
+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"certId" : @"id",
             };
}

@end

@implementation CertificateCourseModel

@end

@implementation CertificateCourseListModel

+ (NSDictionary*)modelContainerPropertyGenericClass
{
    return @{ @"mustCourseList" : [CertificateCourseModel class],@"selectCourseList":[CertificateCourseModel class]};
}


@end
