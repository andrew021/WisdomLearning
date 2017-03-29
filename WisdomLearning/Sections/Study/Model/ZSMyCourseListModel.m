//
//  ZSMyCourseInfo.m
//  WisdomLearning
//
//  Created by Shane on 16/11/4.
//  Copyright © 2016年 hfcb001. All rights reserved.
//

#import "ZSMyCourseListModel.h"

@implementation ZSMyCourseInfo

@end

@implementation ZSMyCourseListModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{ @"pageData":[ZSMyCourseInfo class] };
}

@end
